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
    sha256 = "sha256-XFSe/krgpY7AypCSVo57TpYXHOlU9ms3eLBhKhKYUyU=";
  };

  vendorHash = "sha256-kfiek0QCpi2sRgmFa3ENNc4zTQYX9ocTFlfADu2NGrs=";

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
