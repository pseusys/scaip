import pandas as pd
import json

for subject in ['player', 'unit']:
    with open(f'{subject}-parameters.json') as f:
        parameters = json.load(f)

    parameters_df = []
    for name_type in ['meta', 'obj']:
        type_parameters = [{'type': name_type, 'name': x} for x in parameters['names'][f'{name_type}_names']]
        parameters_df.extend(type_parameters)

    parameters_df = pd.DataFrame(parameters_df)
    parameters_df.to_csv(f'{subject}_parameters.csv', index=False)
