{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  anndata,
  flowio,

}:

buildPythonPackage (finalAttrs: {
  pname = "readfcs";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laminlabs";
    repo = "readfcs";
    tag = finalAttrs.version;
    hash = "sha256-+sj033r+UtIAfhhf3CN2dVp4kZFMk4dKeahLtZHD140=";
  };

  build-system = [ flit-core ];

  dependencies = [
    anndata
    flowio
  ];

  # The only tests run notebooks and require nbproject-test, which is not packaged
  doCheck = false;

  pythonImportsCheck = [ "readfcs" ];

  meta = {
    description = "Parse fcs files into AnnData";
    homepage = "https://github.com/laminlabs/readfcs";
    changelog = "https://github.com/laminlabs/readfcs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
