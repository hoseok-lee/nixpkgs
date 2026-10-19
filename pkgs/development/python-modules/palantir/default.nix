{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  anndata,
  igraph,
  joblib,
  matplotlib,
  mellon,
  ml-dtypes,
  networkx,
  numpy,
  pandas,
  scanpy,
  scikit-learn,
  scipy,

  # optional-dependencies
  h5py,
  pytest,
  pytest-cov,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "palantir";
  version = "1.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dpeerlab";
    repo = "palantir";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9hSLor74K/WQAgdalxOABO0w5p5nDB/a75r3A1b+tnI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    anndata
    igraph
    joblib
    matplotlib
    mellon
    ml-dtypes
    networkx
    numpy
    pandas
    scanpy
    scikit-learn
    scipy
  ];

  optional-dependencies = {
    test-base = [
      h5py
      pytest
      pytest-cov
    ];
  };

  nativeCheckInputs = [
    h5py
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "palantir" ];

  meta = {
    description = "Modeling continuous cell state and cell fate choices in single-cell data";
    homepage = "https://github.com/dpeerlab/palantir";
    changelog = "https://github.com/dpeerlab/palantir/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
