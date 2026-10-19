{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "flowio";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "whitews";
    repo = "FlowIO";
    tag = finalAttrs.version;
    hash = "sha256-j5ft6xx5sbUu7Pv40am2Lm6/RYlsJdBFVDFYmr09uzI=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Off by a few ULPs with recent numpy (max relative difference ~2e-16)
    "test_as_array_with_preprocessing"
  ];

  pythonImportsCheck = [ "flowio" ];

  meta = {
    description = "Read and write Flow Cytometry Standard (FCS) files";
    homepage = "https://github.com/whitews/FlowIO";
    changelog = "https://github.com/whitews/FlowIO/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
