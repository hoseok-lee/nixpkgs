{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jax,
  jaxopt,
  pynndescent,
  scikit-learn,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mellon";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "settylab";
    repo = "mellon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-brLgz98nFwtCLVuZxO0U6LFtsFHUHKIt9b/kCKBMSkw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jax
    jaxopt
    pynndescent
    scikit-learn
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "mellon" ];

  meta = {
    description = "Non-parametric density estimator";
    homepage = "https://github.com/settylab/mellon";
    changelog = "https://github.com/settylab/mellon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
