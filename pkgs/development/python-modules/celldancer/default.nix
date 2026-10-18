{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  anndata,
  bezier,
  datashader,
  joblib,
  jupyterlab,
  matplotlib,
  numpy,
  pandas,
  pytorch-lightning,
  scikit-image,
  scikit-learn,
  scipy,
  seaborn,
  setuptools-scm,
  statsmodels,
  torch,
  tqdm,
  umap-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "celldancer";
  version = "1.1.7";
  pyproject = true;

  # No matching tag in the upstream repository
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xhAh+JNP3qeE1KgN7q8LcQHoWGJHgIz9RO2LGlCD+ac=";
  };

  # pkg_resources was removed from setuptools; locate the bundled models
  # relative to the module instead.
  postPatch = ''
    substituteInPlace src/celldancer/velocity_estimation.py \
      --replace-fail "import pkg_resources" "" \
      --replace-fail "pkg_resources.resource_stream(__name__,os.path.join(" \
        "os.path.join(os.path.dirname(__file__), " \
      --replace-fail ")).name" ")"
  '';

  build-system = [ setuptools ];

  # Every requirement is pinned to an exact (old) version
  pythonRelaxDeps = true;

  dependencies = [
    anndata
    bezier
    datashader
    joblib
    jupyterlab
    matplotlib
    numpy
    pandas
    pytorch-lightning
    scikit-image
    scikit-learn
    scipy
    seaborn
    setuptools
    setuptools-scm
    statsmodels
    torch
    tqdm
    umap-learn
  ];

  # No tests in the source tree
  doCheck = false;

  # pythonImportsCheck compiles numba functions in datashader, which need a
  # writable cache; doCheck = false skips installCheck hooks, so set it here
  postInstall = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "celldancer" ];

  meta = {
    description = "RNA velocity inference using a deep neural network";
    homepage = "https://github.com/GuangyuWangLab2021/cellDancer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
