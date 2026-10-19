{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  anndata,
  h5py,
  matplotlib,
  mudata,
  numba,
  numpy,
  pandas,
  protobuf,
  scanpy,
  scikit-learn,
  scverse-misc,
  seaborn,
  session-info2,
  tqdm,
  umap-learn,

  # tests
  mofapy2,
  pysam,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "muon";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "muon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vnznq+XEf9IB0WtaCjjjSOPSRb98MKgRwGdlLwkGwYY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    anndata
    h5py
    matplotlib
    mudata
    numba
    numpy
    pandas
    protobuf
    scanpy
    scikit-learn
    scverse-misc
    seaborn
    session-info2
    tqdm
    umap-learn
  ];

  nativeCheckInputs = [
    mofapy2
    pysam
    pytestCheckHook
  ];

  disabledTests = [
    # TypeError: cadata should be an ASCII string or a bytes-like object
    "test_filter_obs_with_obsm_obsp"
    "test_filter_var_with_varm_varp"
  ];

  # pythonImportsCheck compiles numba functions, which need a writable cache
  postInstall = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "muon" ];

  meta = {
    description = "Multimodal omics analysis framework";
    homepage = "https://github.com/scverse/muon";
    changelog = "https://github.com/scverse/muon/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
