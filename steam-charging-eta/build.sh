#!/usr/bin/bash

set -euxo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
PACKAGE_DIR="${PWD}"

source ../toolchain.env

rm -rf out
mkdir -p out

podman run --rm \
  --volume "${PACKAGE_DIR}:/work:Z" \
  --workdir /work \
  --platform linux/aarch64 \
  "${BUILDER_IMAGE}" \
  bash -euxo pipefail -c '
    dnf -y install rpm-build rpmdevtools dnf-plugins-core
    rpmdev-setuptree

    cat >/etc/rpm/macros.armada <<EOF
%_buildhost armada-builder
%packager Armada
%vendor Armada
EOF

    cp /work/armada-steam-charging-eta.spec ~/rpmbuild/SPECS/
    cp /work/armada-steam-charging-eta ~/rpmbuild/SOURCES/
    cp /work/armada-steam-charging-eta.service ~/rpmbuild/SOURCES/
    dnf -y builddep ~/rpmbuild/SPECS/armada-steam-charging-eta.spec
    rpmbuild -bb ~/rpmbuild/SPECS/armada-steam-charging-eta.spec

    cp ~/rpmbuild/RPMS/noarch/armada-steam-charging-eta-*.rpm /work/out/
  '

echo "built: ${PACKAGE_DIR}/out"
