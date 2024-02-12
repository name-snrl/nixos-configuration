{ buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "osc";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "theimpostor";
    repo = "osc";
    rev = "v${version}";
    hash = "sha256-4u6n5ECNhbvDBzHsBOEu+jEfwXTPPIDPnSZ2u4MvZFY=";
  };

  vendorHash = "sha256-EABUWDFYosA4319qq4esZGMJoaYIN0dDNLKgQs6t06Q=";
}
