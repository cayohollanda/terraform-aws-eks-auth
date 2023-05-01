import sys
import json
import yaml


def update_map_roles(configmap, map_roles):
    existing_roles = yaml.safe_load(configmap['data']['mapRoles'])

    # Creating a dictionary with the objects (using the rolearn field as a key)
    map_roles_dict = {role['rolearn']: role for role in map_roles}

    # Removing the objects that are not present in the dictionary
    updated_roles = [role for role in existing_roles if role['rolearn'] in map_roles_dict]

    # Updating or adding the objects
    for new_role in map_roles:
        if new_role not in updated_roles:
            updated_roles.append(new_role)

    # Updating the configmap
    configmap['data']['mapRoles'] = yaml.safe_dump(updated_roles, default_flow_style=False).rstrip()

    # Returned configmap
    return configmap

def main(map_roles_json):
    # Opening the file to be used by the script
    with open("aws-auth.yaml", "r") as f:
        configmap = yaml.safe_load(f)

    # Getting roles to be updated in the variable
    map_roles = json.loads(map_roles_json)

    # Call function
    configmap = update_map_roles(configmap, map_roles)

    with open("aws-auth_updated.yaml", "w") as f:
        yaml.safe_dump(configmap, f, default_flow_style=False)


if __name__ == "__main__":
    main(sys.argv[1])
