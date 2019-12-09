# [cross-images](https://registry.hub.docker.com/repository/docker/firstrustcompetition/cross)
Custom images to build for the roboRIO with [cross](https://github.com/rust-embedded/cross)

## Usage
Supply `firstrustcompetition/cross:FRC_UPDATE_SUITE_VERSION` as a custom image to cross.

For example, add the following to your `Cross.toml`:
```toml
[target.arm-unknown-linux-gnueabi]
image = "firstrustcompetition/cross:2019.1.0"
```
Then build: `cross build --target arm-unknown-linux-gnueabi`.

## Generating new images
Create a new release of this repo using an FRC Update Suite version as the tag.
CI will automatically download the suite, extract the roboRIO image, build a cross image, and push to Docker Hub.
