{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
  pysam,
  htseq,
  numpy,
  scipy,
  scikit-learn,
  matplotlib,
  palettable,
  pybedtools,
  pybigwig,
}:

buildPythonPackage (finalAttrs: {
  pname = "biofluff";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonvh";
    repo = "fluff";
    tag = finalAttrs.version;
    hash = "sha256-sg36K/3XH0qRSI8OD6JRdn4H576M5EixVduIUC2BqDc=";
  };

  postPatch = ''
    # matplotlib removed the beginarrow/endarrow arguments; CurveB is "->"
    substituteInPlace fluff/plot.py \
      --replace-fail "ArrowStyle._Curve(beginarrow=False, endarrow=True," "ArrowStyle.CurveB("
    # scipy >= 1.9 requires observed and expected frequencies to have the
    # same sum; rescale the expected profile so only the shapes are compared
    substituteInPlace fluff/util.py \
      --replace-fail "chisquare(profiles[i], profiles[j][::-1])" \
        "chisquare(profiles[i], profiles[j][::-1] * profiles[i].sum() / profiles[j].sum())"
  '';

  build-system = [ setuptools ];

  dependencies = [
    htseq
    matplotlib
    numpy
    palettable
    pybedtools
    pybigwig
    pysam
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Downloads a BAM file
    "test_plots_big"
  ];

  pythonImportsCheck = [ "fluff" ];

  meta = {
    description = "Exploratory analysis and visualization of high-throughput sequencing data";
    homepage = "https://github.com/simonvh/fluff";
    changelog = "https://github.com/simonvh/fluff/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
