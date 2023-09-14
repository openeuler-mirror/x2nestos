# x2nestos

A quick deployment tool for converting a general OS (Like openEuler) to NestOS For Container.

#### Description

Convert to NestOS For Container based on immutable operating systems, based on deployed general OS forms such as OpenEuler.。Suitable for scenarios where it is not convenient to reboot installation or convert in large quantities.

**Attention:**

**1.It's not a migration tools and do NOT preserve disk data.**

**2.This conversion is irreversible.**

#### Installation

This tool is a shell script that can be downloaded or used directly in the Git Clone repository.

If you are using the NestOS For Virt version, the tool is already integrated by default and you can directly execute the x2nestos command.

If you are using openeuler, you can install this tool by executing the following command with epol enabled.

```
sudo dnf install x2nestos
```

#### Instructions

After you complete the installation, you can use this tool as follows:

1. Download the NestOS ISO image to be converted to the local environment as needed, which can be obtained from the [NestOS official website](https://nestos.openeuler.org/)
2. Prepare the ignition file for NestOS For Container deployment. What is an IGN ignition file and how to generate an ignition file? Please refer to the [NestOS official website](https://nestos.openeuler.org/) or the [NestOS user guide](https://docs.openeuler.org/zh/docs/22.03_LTS_SP2/docs/NestOS/overview.html) for reference
3. The current solution of this tool only supports remote acquisition of gn files during the deployment phase. Therefore, you need to provide a URL in the form of HTTP (s) for NestOS to remotely obtain gn files during the deployment phase, such as: http://example.com/xxx.ign <br><br>
   TIPS: An HTTP file service implemented in Python is as follows, executed in the directory where the ign file is located:

   ```
   python -m http.server 8080
   ```

4. Formally start the conversion, execute the following command in the environment to be converted:
   ```
   x2nestos -d DEVICE(required) -i IGNITION_URL(required) -s INSTALL_SOURCE(required)
   ```
   Example:
   ```
   x2nestos -d /dev/vda -i http://example.com/config.ign -s ./nestos-22.03-LTS-SP2.20230704.0-live.x86_64.iso
   ```
5. The complete support parameter list and description are as follows:
   ```
   Usage:
   x2nestos [-d DEVICE] [-i IGNITION_URL] [-s INSTALL_SOURCE]
   -d, --dev DEVICE          Specify the installation target device (e.g., /dev/vda)
   -i, --ignition-url        IGNITION_URL Specify the URL for the Ignition config
   -s, --install-source      The path where the NestOS installation ISO is located, may require you to download it locally in advance
   --debug                   Output every commands during the execution process
   --work_dir                Specify the working directory path, default to /tmp
   -h, --help                Display this help message
   -v, --version             Display Version info
   ```
6. Before the formal start of the conversion, it will be confirmed again whether to execute. Enter y or yes to execute the conversion

enjoy it.

#### Contribution

1.  Fork the repository
2.  Create Feat_xxx branch
3.  Commit your code
4.  Create Pull Request

#### Roadmap

- [x] Basic ability to support openeuler conversion to NestOS
  - [x] Support for manually specifying complete parameters
  - [x] Support for manually specifying ISO paths for automatic mount deployment
  - [ ] Support automatic download of images to be deployed for specified versions
- [ ] Support for retaining data partitions
- [ ] Support retaining the original operating system and deploying NestOS on idle partitions
  - [ ] Automatically compress the current disk space and deploy it after specifying the hard drive and required space
- [ ] Support generating some configurations from the current deployment into the necessary ign files for deploying NestOS
- [ ] Support for selecting NestOS version and release stream to be converted
- [ ] Expanding support for other operating systems
- [ ] ...

#### License

SPDX-License-Identifier: MulanPSL-2.0
