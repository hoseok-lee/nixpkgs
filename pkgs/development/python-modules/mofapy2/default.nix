{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  h5py,
  numpy,
  pandas,
  scikit-learn,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "mofapy2";
  version = "0.7.5";
  pyproject = true;

  # No matching tag in the upstream repository
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-29a2tHivy1NO2+3T9wPL1MSFDMI6QgcWSznS4fuGZGQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    h5py
    numpy
    pandas
    scikit-learn
    scipy
  ];

  # No tests in the source tree
  doCheck = false;

  pythonImportsCheck = [ "mofapy2" ];

  meta = {
    description = "Multi-omics factor analysis";
    homepage = "https://github.com/bioFAM/mofapy2";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
