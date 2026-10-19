{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  celltypist,
  matplotlib,
  networkx,
  numpy,
  pandas,
  plotly,
  scanpy,
  scikit-learn,
  scipy,
  tqdm,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "toomanycells";
  version = "1.0.75";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JRR3";
    repo = "toomanycells";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ubpH4Jti7/HWxEV3JfR7lh59jnI35xdBzI997yQInQ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    celltypist
    matplotlib
    networkx
    numpy
    pandas
    plotly
    scanpy
    scikit-learn
    scipy
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "toomanycells" ];

  meta = {
    description = "Python package for spectral clustering";
    homepage = "https://github.com/JRR3/toomanycells";
    changelog = "https://github.com/JRR3/toomanycells/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
