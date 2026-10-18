{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  param,
  pyct,
  setuptools,
  setuptools-scm,

  # dependencies
  numba,
  numpy,
  pandas,
  scipy,
  urllib3,
  xarray,

  # optional-dependencies
  matplotlib,
  shapely,

  # tests
  dask,
  geopandas,
  hypothesis,
  noise,
  packaging,
  pyarrow,
  pyproj,
  pytest-cov-stub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "xarray-spatial";
  version = "0.10.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "xarray-spatial";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6TgP1lPQoH0OVTcUjyQ7rD7LKNfIe7Lq/WysFW0YOJM=";
  };

  build-system = [
    param
    pyct
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "numpy" ];

  dependencies = [
    numba
    numpy
    pandas
    scipy
    urllib3
    xarray
  ];

  optional-dependencies = {
    plot = [ matplotlib ];
    vector = [ shapely ];
  };

  nativeCheckInputs = [
    dask
    geopandas
    hypothesis
    noise
    packaging
    pyarrow
    pyproj
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
    zstandard
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # Asserts the installed numpy matches the (relaxed) upper bound
    "test_installed_numpy_satisfies_both_declarations"
    # Requires network access
    "test_vertical_crs_attr_is_epsg_int"
  ];

  pythonImportsCheck = [ "xrspatial" ];

  meta = {
    description = "Raster-based spatial analytics for xarray";
    homepage = "https://github.com/xarray-contrib/xarray-spatial";
    changelog = "https://github.com/xarray-contrib/xarray-spatial/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
