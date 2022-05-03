# Isaac ROS Template

**REPOSITORY UNDER CONSTRUCTION**

Do you want to build your own NVIDIA Isaac ROS docker for your robot? this template fit for you!

**You only need to fork this repository!**

# What do you need?

You need:
 * [NVIDIA Jetson](https://developer.nvidia.com/buy-jetson)
   *  NVIDIA Jetson AGX Xavier
   *  NVIDIA Jetson Xavier NX
   *  NVIDIA Jetson Nano (4Gb or 2Gb)
 * [NVIDIA Jetpack 4.6.1](https://developer.nvidia.com/jetpack-sdk-461)

If you are looking to build a docker container for **x86 machines**, please look the [NVIDIA Isaac common](https://github.com/NVIDIA-ISAAC-ROS/isaac_ros_common) repository 

# Where to edit?

There are three parts on this template to edit:
1. [Dockerfile](/Dockerfile)
2. [01_isaac_ros.rosinstall](/01_isaac_ros.rosinstall)
3. [02_your_ros2_pkgs.rosinstall](/02_your_ros2_pkgs.rosinstall)

# Build Isaac ROS Docker image

```
bash build_image.bash [PROJECT_NAME]
```

**PROJECT_NAME** = Name project build

**Options:**
 * **-v** - Verbose
 * **-ci** - Build docker without cache
 * **--push** - Push docker image. Before to push, you need to be logged in
 * **--tag [TAG_NAME]** - Tag release (Default tag: *latest*)
 * **--pull-base-image** - Force to re-pull the base image

This script also *check* in the beginning if:
 1. You are running on ARM64 architecture
 2. Your NVIDIA Jetson have the [right requirements](#what-do-you-need)
 3. Your NVIDIA Jetson use the right NVIDIA runtime container and is able to build a certain of Isaac ROS packages

## Example output

Such as example if you want to build an image `isaac_ros_template` you will need to write:

`bash build_image.bash isaac_ros_template` where the docker image will be: `isaac_ros_template:latest`

# Reference

* [NVIDIA Isaac](https://developer.nvidia.com/isaac)
* [NVIDIA Isaac ROS GEMs](https://developer.nvidia.com/isaac-ros-gems)
* [NVIDIA Isaac ROS GEMs repositories](https://github.com/NVIDIA-ISAAC-ROS)
* [NVIDIA Jetson](https://www.nvidia.com/en-gb/autonomous-machines/embedded-systems/)
* [NVIDIA Jetson containers](https://github.com/dusty-nv/jetson-containers)
* [NVIDIA Jetpack](https://developer.nvidia.com/embedded/jetpack)

Developer blog posts and webinars:
 * [Integrating Isaac ROS Visual Odometry GEM on Jetson](https://info.nvidia.com/isaac-ros-and-nvidia-jetson-wbn.html)
 * [Isaac ROS tutorial](https://github.com/rbonghi/isaac_ros_tutorial)
 * [Designing Robots with NVIDIA Isaac GEMs for ROS](https://developer.nvidia.com/blog/designing-robots-with-isaac-gems-for-ros/)


Robot example with Isaac ROS:
 * [nanosaur.ai](https://nanosaur.ai)
 * [nanosaur architecture](https://nanosaur.ai/architecture/)
 * [nanosaur_perception](https://github.com/rnanosaur/nanosaur_perception) GPU accelerated repository

