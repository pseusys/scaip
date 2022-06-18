# SCAIP
Supreme Commander Artificially Intelligent Player
> _Why do you use SCAIP?_

Thanks a lot to [Softles](https://github.com/HardlySoftly) community member. He offered some of his useful project links:
1. [Command-based AI](https://github.com/HardlySoftly/DilliDalli) (couldn't understand actually how it works, however)
2. [Game auto-run tool](https://github.com/HardlySoftly/FAF-AI-Autorun)

Project consists of three parts:
1. **player** - is a game modification designed for working with neural network model command prediction results and is, basically, a game AI mod.
   It contains scripts for both local (i.e., debug) installation and global mods vault submission.
2. **extractor** - is a game modification designed for feature extraction from replays simulation. Inspired greatly (and in fact extends from) this [AI testing auto-run tool](https://github.com/HardlySoftly/FAF-AI-Autorun).  
   It contains scripts for auto-installing for replay simulation as well as multiple simulation runs (for multiple replays) and data extraction.
3. ...

### Player

TODO

### Extractor

> Requirements: python3.9, pip3  

Install & prepare with:
```bash
pip3 install --user pipenv
python3 -m pipenv install --skip-lock
python3 -m pipenv shell
```  

The package (given its name) actually _extracts_ features from game replay.
For this purpose it has following tools:
- `extractor.py` - script for replay launching with feature extraction mod enabled.
It is also responsible for additional game info extraction (directly from replay file) and storing.
In terms of this app future machine learning process, the script converts **raw replay dataset** to **rich replay dataset**.  
- `replayer.py` - sript for replay downloading, saving, extracting to `.SCFAREPLAY` [format](https://vk.com/away.php?to=https%3A%2F%2Fgist.github.com%2Fyaniv-aknin%2Ffd0155b62f3d673e2c05fee5d8df0ba5&cc_key=) and basic info checking.
E. g. if we are searching for 1v1 replays, this script is responsible for checking & filtering.
In terms of this app future machine learning process, the script prepares **raw replay dataset**.  
- `init_extractor.lua` - a super simple script for hooks loading during replay playing.  
- `extractorhooks/` - folder containing game hooks for feature extraction.
