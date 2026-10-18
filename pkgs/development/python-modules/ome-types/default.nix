{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,
  ruff,
  xsdata,

  # dependencies
  pydantic,
  pydantic-core,
  pydantic-extra-types,

  # optional-dependencies
  lxml,
  pint,

  # tests
  numpy,
  pytest-cov-stub,
  pytestCheckHook,
  xmlschema,
}:

buildPythonPackage (finalAttrs: {
  pname = "ome-types";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "imaging-formats";
    repo = "ome-types";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DQo8wuPVaSfSgS+7+m4fLD1+2DiiEQb5BjXU4nnBWiw=";
  };

  # The model is generated from the OME XSD at build time by a hatch hook,
  # which runs ruff over the generated code and pins an exact ruff version.
  # Newer ruff releases report additional unfixable lints, which must not
  # fail the build.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"ruff ==0.13.2"' '"ruff"'
    substituteInPlace src/ome_autogen/main.py \
      --replace-fail '"--unsafe-fixes", package_dir]' '"--unsafe-fixes", "--exit-zero", package_dir]'
  '';

  build-system = [
    hatch-vcs
    hatchling
    ruff
    xsdata
  ]
  ++ xsdata.optional-dependencies.cli;

  dependencies = [
    pydantic
    pydantic-core
    pydantic-extra-types
    xsdata
  ];

  optional-dependencies = {
    lxml = [ lxml ];
    pint = [ pint ];
  };

  nativeCheckInputs = [
    numpy
    pytest-cov-stub
    pytestCheckHook
    xmlschema
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # TypeError: 'NoneType' object is not iterable in xmlschema 4.3 decoding
    "test_validation_good and xmlschema"
    # Validates with xmlschema on write and hits the same TypeError
    "test_xml_roundtrip and not test_xml_roundtrip_inverse"
  ];

  pythonImportsCheck = [ "ome_types" ];

  meta = {
    description = "Python dataclasses for the OME data model";
    homepage = "https://github.com/imaging-formats/ome-types";
    changelog = "https://github.com/imaging-formats/ome-types/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
