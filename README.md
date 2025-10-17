# EF5 Docker Container

A Docker container for the **Ensemble Framework For Flash Flood Forecasting (EF5)** - a comprehensive hydrological modeling system for flash flood prediction and analysis.

## Overview

This Docker image provides a containerized environment for running EF5, enabling easy deployment and consistent execution across different systems. EF5 is designed for ensemble-based flash flood forecasting using advanced hydrological modeling techniques.

## Features

- **Standalone EF5 Environment**: Complete EF5 installation in a containerized environment
- **Ubuntu Base**: Built on Ubuntu for maximum compatibility
- **Pre-compiled**: EF5 is automatically compiled during image build
- **Development Ready**: Includes build tools and dependencies

## Quick Start

### Prerequisites

- Docker installed on your system
- Basic understanding of hydrological modeling (recommended)

### Building the Image

```bash
# Clone this repository
git clone https://github.com/Flood-Lab/EF5-docker.git
cd EF5-docker

# Build the Docker image
docker build -t ef5-docker .
```

### Running the Container

#### Interactive Mode
```bash
# Run the container interactively
docker run -it ef5-docker /bin/bash

# Run with volume mounting for data persistence
docker run -it -v /path/to/your/data:/data ef5-docker /bin/bash
```

#### Direct EF5 Execution
```bash
# Run EF5 directly with arguments
docker run --rm -v /path/to/your/data:/data ef5-docker /EF5/bin/ef5 [arguments]

# Example: Run EF5 with configuration file
docker run --rm -v /path/to/your/data:/data ef5-docker /EF5/bin/ef5 -c /data/config.txt

# Example: Run EF5 with help to see available options
docker run --rm ef5-docker /EF5/bin/ef5 --help
```

## Usage

### Command Line Arguments

EF5 typically accepts the following types of arguments:

#### Basic Usage
```bash
# Check available options
docker run --rm ef5-docker /EF5/bin/ef5 --help

# Run with configuration file
docker run --rm -v /path/to/data:/data ef5-docker /EF5/bin/ef5 -c /data/config.txt

# Run with specific output directory
docker run --rm -v /path/to/data:/data ef5-docker /EF5/bin/ef5 -c /data/config.txt -o /data/output

# Run with verbose output
docker run --rm -v /path/to/data:/data ef5-docker /EF5/bin/ef5 -c /data/config.txt -v
```

#### Common Argument Patterns
```bash
# Configuration file (required)
-c /path/to/config.txt
--config /path/to/config.txt

# Output directory
-o /path/to/output
--output /path/to/output

# Input data directory
-i /path/to/input
--input /path/to/input

# Verbose mode
-v
--verbose

# Help
-h
--help
```

### Volume Mounting for Data

```bash
# Mount your data directory
docker run --rm \
  -v /host/data:/data \
  ef5-docker \
  /EF5/bin/ef5 -c /data/config.txt -o /data/output

# Mount multiple directories
docker run --rm \
  -v /host/input:/data/input \
  -v /host/output:/data/output \
  -v /host/config:/data/config \
  ef5-docker \
  /EF5/bin/ef5 -c /data/config/config.txt -o /data/output
```

### Interactive Development

```bash
# Start interactive session
docker run -it \
  -v /path/to/your/data:/data \
  ef5-docker /bin/bash

# Inside the container:
cd /EF5
./bin/ef5 --help
./bin/ef5 -c /data/config.txt
```

### Environment Variables

You can also pass environment variables to configure EF5 behavior:

```bash
# Set environment variables
docker run --rm \
  -v /path/to/data:/data \
  -e EF5_CONFIG_PATH=/data/config \
  -e EF5_OUTPUT_PATH=/data/output \
  ef5-docker \
  /EF5/bin/ef5 -c /data/config.txt
```

### Complete Example

Here's a complete example of running EF5 with a typical hydrological modeling workflow:

```bash
# 1. Prepare your data structure
mkdir -p /host/data/{input,output,config}

# 2. Copy your configuration and data files
cp your_config.txt /host/data/config/
cp your_dem.tif /host/data/input/
cp your_precip.nc /host/data/input/

# 3. Run EF5 with all necessary arguments
docker run --rm \
  -v /host/data:/data \
  --name ef5-simulation \
  ef5-docker \
  /EF5/bin/ef5 \
    -c /data/config/your_config.txt \
    -i /data/input \
    -o /data/output \
    -v

# 4. Check results
ls /host/data/output/
```

## Project Structure

```
EF5-docker/
├── Dockerfile          # Docker configuration
├── README.md          # This file
└── .gitignore         # Git ignore rules
```

## Technical Details

### Base Image
- **OS**: Ubuntu 22.04 LTS
- **Architecture**: Multi-platform support (tested on ARM64 and x86_64)

### Installed Software
- Git (for cloning EF5 repository)
- GCC and build-essential (for compilation)
- Make (build system)
- libgeotiff-dev (geospatial data support)
- dh-autoreconf (autotools support)
- Additional build tools: autoconf, automake, libtool, pkg-config

### EF5 Installation
- **Source**: [HyDROSLab/EF5](https://github.com/HyDROSLab/EF5.git)
- **Version**: Latest from main branch
- **Build Process**: Automated compilation during image build
- **Compilation Fixes**: Modified to handle buffer overflow warnings gracefully

## Troubleshooting

### Build Issues

If you encounter compilation errors during the Docker build:

1. **Buffer Overflow Warnings**: The EF5 source code contains some buffer overflow warnings in `DatedName.cpp`. These are handled by:
   - Removing the `-Werror` flag from the Makefile
   - Treating warnings as warnings instead of errors
   - This allows the build to complete successfully

2. **Missing Dependencies**: Ensure all required packages are installed:
   ```bash
   # The Dockerfile automatically installs all dependencies
   # If building manually, install:
   sudo apt-get install git gcc g++ build-essential make libgeotiff-dev dh-autoreconf autotools-dev autoconf automake libtool pkg-config
   ```

3. **Architecture Compatibility**: The container is tested on:
   - ARM64 (Apple Silicon, ARM servers)
   - x86_64 (Intel/AMD processors)

### Runtime Issues

1. **Permission Errors**: If you encounter permission issues when mounting volumes:
   ```bash
   # Run with proper user mapping
   docker run -it --user $(id -u):$(id -g) -v /path/to/data:/data ef5-docker /bin/bash
   ```

2. **Missing Input Data**: Ensure you have the required input files for EF5:
   - Configuration files
   - DEM data
   - Meteorological data
   - Basin boundary files

## Contributing

We welcome contributions to improve this Docker container! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is part of the Flood-Lab organization's efforts to advance scientific understanding and practical mitigation of floods through the integration of AI, remote sensing, and physical modeling.

## Contact

- **Maintainer**: Zhi Li <Zhi.Li-2@colorado.edu>
- **Organization**: [Flood-Lab](https://github.com/orgs/Flood-Lab)
- **Website**: https://hydrors.us/

## Related Projects

- [AQUAH](https://github.com/Flood-Lab/AQUAH) - First-of-its-kind hydrologic agent for automated data processing and modeling
- [EF5 Source](https://github.com/HyDROSLab/EF5) - Original EF5 framework repository

## Acknowledgments

This Docker container is built for the Flood-Lab organization, which thrives to advance scientific understanding and practical mitigation of floods through the integration of AI, remote sensing, and physical modeling.

---

*For more information about EF5 and its capabilities, please refer to the [official EF5 documentation](https://github.com/HyDROSLab/EF5) and the [Flood-Lab website](https://hydrors.us/).*
