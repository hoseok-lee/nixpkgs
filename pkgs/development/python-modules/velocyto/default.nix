{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  llvmPackages,

  # build-system
  cython,
  numpy,
  setuptools,

  # dependencies
  click,
  h5py,
  loompy,
  matplotlib,
  numba,
  pandas,
  pysam,
  scikit-learn,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "velocyto";
  version = "0.17.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "velocyto-team";
    repo = "velocyto.py";
    tag = finalAttrs.version;
    hash = "sha256-fdJ0ToJKdX5ZKiS/eqCLxEYNeeHr7ySms0WQut25oCI=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  # cython is only needed to compile the extension
  pythonRemoveDeps = [ "cython" ];

  dependencies = [
    click
    h5py
    loompy
    matplotlib
    numba
    numpy
    pandas
    pysam
    scikit-learn
    scipy
  ];

  # No tests in the source tree
  doCheck = false;

  # pythonImportsCheck compiles numba functions, which need a writable cache
  postInstall = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "velocyto"
    "velocyto.speedboosted"
  ];

  meta = {
    description = "RNA velocity analysis for single cell RNA-seq data";
    homepage = "https://velocyto.org/velocyto.py/";
    changelog = "https://github.com/velocyto-team/velocyto.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hoseok-lee ];
    mainProgram = "velocyto";
  };
})
