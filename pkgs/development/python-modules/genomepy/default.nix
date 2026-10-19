{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  htslib,

  # build-system
  hatchling,

  # dependencies
  appdirs,
  biopython,
  click,
  colorama,
  diskcache,
  filelock,
  loguru,
  mygene,
  mysql-connector-python,
  numpy,
  pandas,
  pyfaidx,
  pyyaml,
  requests,
  tqdm,

  # tests
  bowtie2,
  bwa,
  minimap2,
  pytestCheckHook,
  star,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "genomepy";
  version = "0.16.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vanheeringen-lab";
    repo = "genomepy";
    tag = finalAttrs.version;
    hash = "sha256-aVx5JQEVR6vXh1knbY5+DVm8dLdtLwlQIOgM+6htqXI=";
  };

  postPatch = ''
    substituteInPlace genomepy/files.py \
      --replace-fail 'f"bgzip {fname}"' 'f"${lib.getExe' htslib "bgzip"} {fname}"'
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "mysql-connector-python" ];

  dependencies = [
    appdirs
    biopython
    click
    colorama
    diskcache
    filelock
    loguru
    mygene
    mysql-connector-python
    numpy
    pandas
    pyfaidx
    pyyaml
    requests
    tqdm
  ];

  # Aligners used by the index plugin tests
  nativeCheckInputs = [
    bowtie2
    bwa
    minimap2
    pytestCheckHook
    star
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Require network access to genome providers
    "tests/test_04_online.py"
    "tests/test_06_provider_base.py"
    "tests/test_07_provider_ncbi.py"
    "tests/test_08_provider_ucsc.py"
    "tests/test_08b_provider_gencode.py"
    "tests/test_09_provider_ensembl.py"
    "tests/test_10b_provider_url.py"
    "tests/test_11_provider.py"
    "tests/test_e01_link_options.py"
    "tests/test_e02_install_options.py"
    "tests/test_e03_human_genomes.py"
  ];

  disabledTests = [
    # Require network access to genome providers
    "test__lazy_provider_selection"
    "test__provider_selection"
    "test_install_genome"
    "test_list_available_genomes"
    "test_argparse_plugin"
    # Depend on the genome installed by test_install_genome
    "test_generate_env"
    "test_generate_exports"
    # Require the UCSC tools (kent), which are only packaged for Linux
    "test_check_ucsc_tools"
    "test_generate_annot"
    "test_head_annotations"
    # hisat2 is only packaged for x86 Linux
    "test_hisat2"
    # Runs black/flake8/isort over the source tree
    "test_linting"
  ];

  pythonImportsCheck = [ "genomepy" ];

  meta = {
    description = "Genes and genomes at your fingertips";
    homepage = "https://github.com/vanheeringen-lab/genomepy";
    changelog = "https://github.com/vanheeringen-lab/genomepy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
