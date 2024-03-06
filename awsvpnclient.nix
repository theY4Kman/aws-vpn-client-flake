{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, openvpn
, xdg-utils
}:

buildGoModule rec {
  pname = "awsvpnclient";
  version = "3acc955dbf6c7a5881ea853556a7f53963bc0f01";

  src = fetchFromGitHub {
    owner = "they4kman";
    repo = "aws-vpn-client";
    rev = "${version}";
    sha256 = "sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=";
  };

  vendorHash = "sha256-602xj0ffJXQW//cQeByJjtQnU0NjqOrZWTCWLLhqMm0=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    cp ${src}/awsvpnclient.yml.example $out/awsvpnclient.yml

    substituteInPlace $out/awsvpnclient.yml \
      --replace /home/myname/aws-vpn-client/openvpn "openvpn" \
      --replace /usr/bin/sudo "sudo"

    makeWrapper $out/bin/aws-vpn-client $out/bin/awsvpnclient \
      --run "cd $out" \
      --prefix PATH : "${lib.makeBinPath [ openvpn xdg-utils ]}"
  '';

}
