{ mkDerivation, base, bytestring, QuickCheck, stdenv
, test-framework, test-framework-quickcheck2, text
}:
mkDerivation {
  pname = "querystring-pickle";
  version = "0.2.0";
  src = ./.;
  libraryHaskellDepends = [ base bytestring text ];
  testHaskellDepends = [
    base bytestring QuickCheck test-framework
    test-framework-quickcheck2
  ];
  description = "Picklers for de/serialising Generic data types to and from query strings";
  license = "unknown";
}
