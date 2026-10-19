{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  leidenalg,
  matplotlib,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  torch,
  umap-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "scmomat";
  version = "0.2.2";
  pyproject = true;

  # No matching tag in the upstream repository
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-LHgCpPoLIT9XQPVlFkM4JMUVL18czpxMoJXxvtP43GU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    leidenalg
    matplotlib
    numpy
    pandas
    scikit-learn
    scipy
    torch
    umap-learn
  ];

  # All tests are scripts that need datasets not included in the source
  doCheck = false;

  # pythonImportsCheck compiles numba functions, which need a writable cache
  postInstall = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "scmomat" ];

  meta = {
    description = "Single-cell multi-omics mosaic integration method";
    homepage = "https://github.com/PeterZZQ/scMoMaT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
