{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  click,
  leidenalg,
  numpy,
  openpyxl,
  pandas,
  requests,
  scanpy,
  scikit-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "celltypist";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teichlab";
    repo = "celltypist";
    tag = finalAttrs.version;
    hash = "sha256-m2zoHwLH6CCGdmiNsiMO9HmumeWaJpGkqMtSNBVPQcE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    leidenalg
    numpy
    openpyxl
    pandas
    requests
    scanpy
    scikit-learn
  ];

  # No tests in the source tree
  doCheck = false;

  # pythonImportsCheck compiles numba functions, which need a writable cache
  postInstall = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
    # Importing celltypist creates ~/.celltypist
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "celltypist" ];

  meta = {
    description = "Tool for semi-automatic cell type classification";
    homepage = "https://github.com/Teichlab/celltypist";
    changelog = "https://github.com/Teichlab/celltypist/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
