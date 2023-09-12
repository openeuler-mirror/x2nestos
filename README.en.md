# x2nestos

A quick deployment tool for converting a general OS (Like openEuler) to NestOS.

#### Description

Convert to NestOS based on immutable operating systems, based on deployed general OS forms such as OpenEuler.。Suitable for scenarios where it is not convenient to reboot installation or convert in large quantities.

**Attention:**

**1.It's not a migration tools and do NOT preserve disk data.**

**2.This conversion is irreversible.**

#### Installation

// todo

#### Instructions

// todo

#### Contribution

1.  Fork the repository
2.  Create Feat_xxx branch
3.  Commit your code
4.  Create Pull Request

#### Roadmap

- [✔] Basic ability to support openeuler conversion to NestOS
  - [✔] Support for manually specifying complete parameters
  - [ ] Support for manually specifying ISO paths for automatic mount deployment
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
