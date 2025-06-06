{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libraspberrypi";
  version = "unstable-2024-12-23";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "a54a0dbb2b8dcf9bafdddfc9a9374fb51d97e976";
    hash = "sha256-Edca6nkykdXKFF5MGq6LeKirMLHTZBCbFWvHTNHMWJ4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  cmakeFlags = [
    # -DARM64=ON disables all targets that only build on 32-bit ARM; this allows
    # the package to build on aarch64 and other architectures
    "-DARM64=${if stdenv.hostPlatform.isAarch32 then "OFF" else "ON"}"
    "-DVMCS_INSTALL_PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "ARM side libraries for interfacing to Raspberry Pi GPU";
    homepage = "https://github.com/raspberrypi/userland";
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ dezgeg tkerber ];
  };
})