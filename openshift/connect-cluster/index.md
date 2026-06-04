# Connect to the Cluster

In this lab you will clone the course repository, set up VS Code for remote development, and connect to your bastion host using the SSH key included in the repository.

## Clone the Course Repository

Open VS Code and press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac) to open the **Command Palette**. Type `Git: Clone` and select it.

When prompted for the repository URL, enter:

```
https://github.com/innovationinsoftware/bc-mainframe-app-dev.git
```

A folder picker will open — navigate to your `Downloads` folder and click **Select as Repository Destination**. VS Code will clone the repository and prompt you to open it. Click **Open**.

This creates a `bc-mainframe-app-dev` directory inside `~/Downloads`. The `keys/` subdirectory contains the `lab.pem` SSH key you will use to connect to the bastion host.

## Set Up VS Code for Remote Development

Throughout this course, you will use **Visual Studio Code** as your primary tool for editing files and running terminal commands on the bastion host. VS Code's **Remote - SSH** extension lets you open a full editor session on a remote machine — you get syntax highlighting, file browsing, multi-file editing, and an integrated terminal, all running against the bastion host as if it were local.

This is a significant improvement over working with command-line text editors like `vi`. You can see the entire file, make precise edits visually, and keep multiple files open at once.

### Create an SSH Config File

An SSH config file tells VS Code (and the `ssh` command) how to connect to a host by name, without having to remember IP addresses, usernames, and key paths every time. This is the same file that system administrators use to manage dozens or hundreds of servers.

Open VS Code and press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac) to open the **Command Palette**. Type `Remote-SSH: Open SSH Configuration File` and select it. VS Code will present a list of config file paths — select the **first option** in the list. This is the user-level SSH config file and is the correct choice on both Mac/Linux and Windows.

If the file does not exist, VS Code will create it for you. If it already exists, look for an existing `Host` entry and update it. Either way, ensure the file contains the following entry with the values below:

```
Host bastion
    HostName <BASTION_IP>
    User ec2-user
    IdentityFile ~/Downloads/bc-mainframe-app-dev/openshift/keys/lab.pem
```

Replace `<BASTION_IP>` with the IP address provided by the instructor.

Save the file.

### Connect to the Bastion Host

Now use the Remote Explorer to connect:

1. Click the **Remote Explorer** icon in the VS Code sidebar (it looks like a monitor icon).
2. You should see **bastion** listed under the SSH section.
3. Click the connect icon next to **bastion** (or right-click and select **Connect in Current Window**).
4. VS Code will ask you to select the platform of the remote host — choose **Linux**.
5. The first connection takes a moment while VS Code installs its server component on the bastion. Once connected, the bottom-left corner of VS Code will show `SSH: bastion`.

You now have a full VS Code session running on the bastion host. The file explorer on the left shows the bastion's filesystem, and any terminal you open runs commands on the bastion.

### Open the Remote Folder

Once connected, open the home directory on the bastion so you can browse and edit files from the VS Code file explorer:

1. Go to **File > Open Folder**.
2. In the path field, type `/home/ec2-user` and click **OK**.
3. VS Code may prompt you to confirm you trust the remote — click **Yes, I trust the authors**.

The file explorer on the left now shows the contents of the bastion's home directory. You can create, open, and edit files here just as you would locally.

### Open a Terminal

Open the integrated terminal by pressing `` Ctrl+` `` (backtick) or going to **Terminal > New Terminal** in the menu bar. This terminal is running on the bastion host — every command you type here executes remotely, just as if you had SSH'd in from a traditional terminal.

You will use this integrated terminal throughout the labs.
