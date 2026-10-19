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
  numpy,
  pandas,
  scipy,
  scverse-misc,
  session-info2,

  # optional-dependencies
  fsspec,
  zarr,

  # tests
  pytestCheckHook,
  dask,
  fast-array-utils,
  jsonschema,
  packaging,
  referencing,
}:

buildPythonPackage (finalAttrs: {
  pname = "mudata";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "mudata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vxVSl1T5r3C1HiHHaOv2BBDJR719Sfvu3+f547kD1O4=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    anndata
    h5py
    numpy
    pandas
    scipy
    scverse-misc
    session-info2
  ];

  optional-dependencies = {
    io = [
      fsspec
      zarr
    ];
  };

  nativeCheckInputs = [
    dask
    fast-array-utils
    jsonschema
    packaging
    pytestCheckHook
    referencing
  ]
  ++ finalAttrs.passthru.optional-dependencies.io;

  disabledTests = [
    # Fetch the JSON schema from the network
    "test_to_from_json"
  ];

  pythonImportsCheck = [ "mudata" ];

  meta = {
    description = "Multimodal data container built on AnnData";
    homepage = "https://github.com/scverse/mudata";
    changelog = "https://github.com/scverse/mudata/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
