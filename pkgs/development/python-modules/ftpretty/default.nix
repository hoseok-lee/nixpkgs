{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  python-dateutil,
}:

buildPythonPackage (finalAttrs: {
  pname = "ftpretty";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codebynumbers";
    repo = "ftpretty";
    tag = finalAttrs.version;
    hash = "sha256-gMGdmjMRsEs4EfQ1xR1JIF6PVdqgRM9SB7CXFDal3dE=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  # Tests require the python-libfaketime bindings, which are not packaged
  doCheck = false;

  pythonImportsCheck = [ "ftpretty" ];

  meta = {
    description = "Pythonic wrapper around ftplib";
    homepage = "https://github.com/codebynumbers/ftpretty";
    changelog = "https://github.com/codebynumbers/ftpretty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
