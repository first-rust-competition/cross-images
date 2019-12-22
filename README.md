# [cross-images](https://registry.hub.docker.com/repository/docker/firstrustcompetition/cross)
Custom images to build for the roboRIO with [cross](https://github.com/rust-embedded/cross)

## Usage
Supply `firstrustcompetition/cross:IMAGE_VERSION` as a custom image to cross.

For example, add the following to your `Cross.toml`:
```toml
[target.arm-unknown-linux-gnueabi]
image = "firstrustcompetition/cross:2020_v10"
```
Then build: `cross build --target arm-unknown-linux-gnueabi`.

## Version tuples
RoboRIO images are indentified using a tuple of three versions.

1. The *year*, which identifies which ni-frc-XXXX-game-tools package to introspect
2. The *game tools version*, which identifies which in-year version of the game tools package to introspect
3. The *FRC utilities version*, which contains the actual image.

You'll typically want all of these to be on the latest version.

```
2020_19.0_19.0.0.49153-0+f1
^    ^    ^
|    |    |
|    |    utilities version
|    |
|    game tools version
|
year
```

## Generating new images
Create a new release of this repo using a version tuple as the tag.
CI will automatically download the suite, extract the roboRIO image, build a cross image, and push to Docker Hub.
