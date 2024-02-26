# Ansible Player Repository

Hello and welcome to the Ansible Player repository! Before we dive into how to use this repo, let me first provide some context about its purpose and limitations.

> Note: The current setup is **NOT** recommended for use in a production environment. Instead, it has been created primarily as a convenient tool for managing home lab machines.

Now, onto the fun stuff! To get started with the Ansible Player, follow these simple steps:

1. Open up your terminal application and navigate to the location where you have downloaded or cloned this repository.

1. Run the following command, replacing "PLAYBOOK_NAME" with the name of the playbook you want to execute (without the .yaml extension):

```bash
bash run.sh -d PLAYBOOK_NAME
```

## Example

Here are some examples of how to use the Ansible player:

- If you wanted to execute a playbook named **'apt_update.yaml'**, you would enter:

  ```bash
  bash run.sh -d apt_update
  ```

## Additional Information

Need more information about the run.sh script? Type:

```bash
bash run.sh -h
```

This will display a helpful message containing details about the various flags and parameters that you can use when running the script.

Happy automating!
