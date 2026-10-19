{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  ftpretty,
  numpy,
  openpyxl,
  pandas,
  pydot,
  requests,
  rich,
  scipy,
  statsmodels,
  xlsxwriter,

}:

buildPythonPackage (finalAttrs: {
  pname = "goatools";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tanghaibao";
    repo = "goatools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ekfQiThx0bEAUO5LYlfTTzPMWtcAbz5D9f9u4L6G0tM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_scm_git_archive",' ""
    # pkgutil.find_loader was removed in Python 3.14
    substituteInPlace goatools/grouper/read_goids.py \
      --replace-fail "import pkgutil" "import importlib.util" \
      --replace-fail "pkgutil.find_loader(sections_file)" \
        "importlib.util.find_spec(sections_file)"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ftpretty
    numpy
    openpyxl
    pandas
    pydot
    requests
    rich
    scipy
    setuptools
    statsmodels
    xlsxwriter
  ];

  # Most tests download GO and annotation files, and the suite takes several
  # hours to run
  doCheck = false;

  pythonImportsCheck = [ "goatools" ];

  meta = {
    description = "Python scripts to find enrichment of GO terms";
    homepage = "https://github.com/tanghaibao/goatools";
    changelog = "https://github.com/tanghaibao/goatools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
