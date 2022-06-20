import asyncio
from asyncio import create_subprocess_exec
from asyncio.subprocess import STDOUT, PIPE
from logging import getLogger
from os import name, walk, path, remove
from pathlib import Path
from shutil import copyfile
from tempfile import NamedTemporaryFile
from zipfile import ZipFile

# from fafreplay import extract_scfa
from temp_support import extract_scfa  # TODO: remove


_ARCHIVE_NAME = 'extractor.ext'
_INIT_NAME = 'init_extractor.lua'

_log = getLogger(__name__)


def _get_faforever_dir():
    if name == 'nt':
        return Path('C:/ProgramData/FAForever')
    else:
        return Path.home() / '.faforever'


def _get_current_dir():
    return Path(path.dirname(path.realpath(__file__)))


def _zip_add_dir(f, directory):
    for root, _, files in walk(directory):
        for filename in files:
            file = path.join(root, filename)
            _log.debug(f"Adding {file}")
            f.write(file)


def _install_mod():
    dest = _get_faforever_dir() / 'gamedata' / _ARCHIVE_NAME
    _log.info(f"Creating zip file {dest}")
    with ZipFile(dest, 'w') as f:
        _zip_add_dir(f, 'lua')
        _zip_add_dir(f, 'extractorhook')

    dest = _get_faforever_dir() / "bin" / _INIT_NAME
    _log.info(f"Copying init file {dest}")
    copyfile(_get_current_dir() / _INIT_NAME, dest)

    _log.info("Done!")


def _uninstall_mod():
    faf_dir = _get_faforever_dir()
    archive = faf_dir / 'gamedata' / _ARCHIVE_NAME
    init_file = faf_dir / 'bin' / _INIT_NAME

    _log.info(f"Removing {archive}")
    remove(archive)

    _log.info(f"Removing {init_file}")
    remove(init_file)

    _log.info("Done!")


def _parse_replay(replay):
    if replay.name.endswith('.fafreplay'):
        temp_replay_file = NamedTemporaryFile(suffix='.scfareplay', delete=False)
        with open(replay, 'rb') as f:
            temp_replay_file.write(extract_scfa(f))
            temp_replay_file.close()
        return Path(temp_replay_file.name), True
    else:
        return replay, False


async def _run_game(extract_player, extract_file, replay) -> int:
    program = _get_faforever_dir() / 'bin' / 'ForgedAlliance.exe'
    args = [
        '/nomovie',
        '/nomusic',
        '/nosound',
        '/exitongameover',
        # '/debug',  # TODO: remove
        '/log', "C:\\ProgramData\\FAForever\\replays\\17301304-SusSusAmogus.logfile",
        '/replay', replay,
        '/init', _get_faforever_dir() / 'bin' / _INIT_NAME,
        '/extract_player', extract_player,
        '/extract_file', extract_file
    ]
    _log.debug(f"Running with args: {args[1:]}")
    process = await create_subprocess_exec(program, *args, stdout=PIPE, stderr=STDOUT)
    code = await process.wait()
    return code


async def extract(interest_player: str, replay_files: [Path], destination: Path) -> int:
    _install_mod()

    for replay_file in replay_files:
        parsed_replay, delete_replay = _parse_replay(replay_file)

        await _run_game(interest_player, destination, parsed_replay)

        if delete_replay:
            remove(parsed_replay)

    _uninstall_mod()

    _log.info("Done!")
    return 0


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(extract("me", [Path("C:\\ProgramData\\FAForever\\replays\\17301304-SusSusAmogus.fafreplay")], Path("C:\\ProgramData\\FAForever\\replays\\17301304-SusSusAmogus.extractedreplay")))
