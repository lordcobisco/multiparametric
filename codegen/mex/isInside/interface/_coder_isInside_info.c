/*
 * _coder_isInside_info.c
 *
 * Code generation for function '_coder_isInside_info'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "isInside.h"
#include "_coder_isInside_info.h"

/* Function Definitions */
mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xResult;
  mxArray *xEntryPoints;
  const char * fldNames[6] = { "Name", "NumberOfInputs", "NumberOfOutputs",
    "ConstantInputs", "FullPath", "TimeStamp" };

  mxArray *xInputs;
  const char * b_fldNames[4] = { "Version", "ResolvedFunctions", "EntryPoints",
    "CoverageInfo" };

  xEntryPoints = emlrtCreateStructMatrix(1, 1, 6, fldNames);
  xInputs = emlrtCreateLogicalMatrix(1, 3);
  emlrtSetField(xEntryPoints, 0, "Name", emlrtMxCreateString("isInside"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs", emlrtMxCreateDoubleScalar(3.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs", emlrtMxCreateDoubleScalar
                (2.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(xEntryPoints, 0, "FullPath", emlrtMxCreateString(
    "G:\\Meu Drive\\ISD\\orientacoes\\Domingos\\multivariateLimbControl\\isInside.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp", emlrtMxCreateDoubleScalar
                (737653.70621527778));
  xResult = emlrtCreateStructMatrix(1, 1, 4, b_fldNames);
  emlrtSetField(xResult, 0, "Version", emlrtMxCreateString(
    "9.5.0.944444 (R2018b)"));
  emlrtSetField(xResult, 0, "ResolvedFunctions", (mxArray *)
                emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  const char * data[21] = {
    "789ced5dcd6fdbc815a78364911c52b005daecf6639b608bc516014cd9923fb4455bebdb92ad6fdb929d666d4aa2245a2447222946f6493db4e8b1971e0a14e8"
    "ad280a74919e1a60f7e0a297fe01dd3deca99705fa0fb4d7969434b638abb194882245691e608cc6cf9a377c7e7cbf796fbea895787285a2a8afe93f77f49fab",
    "4fa81e3dec17143d28ef506642f92b83f2fb481dd23dea6eaf8d8708ff7783b20c2495eba8fd8ac04b5caa2d963859af48acc85d375301222fb1927a70d1e428"
    "995380a071951ea7ca0bdc012f72fb60a8b2cbeb15313ac4baae182ce373a8ce951bf9b648c975e5a6bbc270851ad2cf4bccf3df9d503f7b18fdd008ff59e479",
    "ec4326c9b51f87655ee398783ecc0099e724952d034e61c286226a4061c4b6a0f21a2bf3accaedf36229a42b520602c32b7149e12bdcaa68eaffd950ff5686e4"
    "be35a2ffc3fc154c09e901757fa8f67807caeb60da1ba5af51f2be8e9147237c4e144e4555ffbf2aa7754e68f62cc7a071cf3dae1f28e1fa0109ca7bf586f260",
    "fbb931f220ff597cbf18791efe90c9c8a026b3e263c3a695c71f74b6377fc8245955604b8c0a8050021d46d71123f02546ecff1a3415e62b6a1b988b8df6d2fd"
    "eddbddcf03f6daa7ddef8373f2a67dffbe85914723fc9364b57394e8f853e57aea241fdb976a15e089def4233346ceb87e5098ba5ded5f61be3fa91ecf30edd3",
    "08dffaf7f949198822904ecb06d029f0799a98fe4e6a8777903aa407c873f529bdd32f33d7b8d0c5b43fa93e71e30c1ae19741455702af0f2e648915567925d8"
    "e605352ee9c30b4ee6cb53e30394ff1652bfe94f9f5301ed92c059870f8531cf0ff9af6b4fc6cfd39ed298a7506b0caa351d246cc487bffee78bcf083ecc489e",
    "5df890d65aa1407557db3ec8fa2eca11515a8f9e08bb8b830f64bc37ba8464b6bf846538f06d8c3c1ae1233850125865b5af883edfad3890c7ca33f32dc181a7"
    "86da98bedaec8f2b1f7df1371227cc2b0e7c13238f46f81c086f8ba9eaf6c55e432e821c573adf3f6c53040796f07dd6e907738103bc64241cfb7cb7e68b1cb0",
    "9bbedaecb79bcdfb3fff27c18119c9b32b1e0896d880124cf9329ab09d955475bbd068b56204079613073eb06cbee011461e8df0111c50caacc0ca919a6371c0"
    "cb29e5a5c73c37e45b622f505bf6e6813e7eff2332fe77bbdff7e46a6b9a9af003b95657f251b6168cc6b5f0e2f87df21e8feebfc9eebac96b7f8f9b8798545f",
    "0f31f26884cf2b523f77ad1a2b079ccbf74c6b1f29ac3c33ff4df28455bec3559a40370fc6a42e634860a37dfcb9f00ec9f7bbddcfc7bc8d8b7cabc60ba18350"
    "23d70ad60e1a8711e2e797d6cfe3e44daaaffb481d123de0f04a951759b5ee56bf1ec7ca33f3a7f6eb7d35c1691fe2d717449e5df97badc5459a5a59f1175f78",
    "01c828f935eff109b5387edd55eb326efcfa932a2f2b6a95b7d7feaece2ccbdfbf8b9147237c63025b7ffed32a9005009aa740e3e4aa005ef497373997bfbf7a"
    "4379b0fdd331f2207f8af9ff8119dda23e5bc707579f7e798fe473e6150f261de72b7b914e247c79994974d67dc9754f281b58f34416070ffe8df9fea47afc05",
    "a67d1ae1cff8bd7e72fb1fdcac99b7d75e6396c50777913a247ac03106be46e9f03c032f55b84e5c52affbf1c729fb1119d30fc8b7206ee8c50c36dac72bb2ee"
    "d3fdf890bf68f2e2462b5758e34b155ffc249b49ae2d52be9fbcbf6632db9b6761f2fce3f0a55c677b5bce489e7f740989e48316cbbf2f7a9e9f8cff6769af71",
    "cbc6ffe3f2f5fab38b6cc7bd7830cbf901684782fe81e92bca81f981ab578f1e907c90dbf1406e799ae7bce20b889b992d29532a7af78e9420c1038207a39fdb"
    "3c5f6c2f1ef012c18389f080979cc0834f081eb81f0f6aecf156da5b48b5b64a0135b4c1a67d9c2f4bd6f95fb7b754f3c5ff3ab3ccbfbf6ebe7f5a79afbb1e88",
    "e405cd44f2fa8be5d7173dafef56bf7ec9c94069dface3c0e5dd6772cecfcef39d5e79f533dbfc7cb52d084649d67d62c7f14a9395ab6d893154e5c038befb17"
    "92e777bfbf5737d7c55cb810ab9f78c1a5a626c568724d25fefebabd79d9affb6b4c3f27b53f9cff83fede33fccb6e74a7ff21d62fbb8392da1dd407e5509edf",
    "a1753783731ed4a97102255c3f2059851319a48eca837c4bcf77505745fbfcdaceff7ef91392ef713b4e346b71a5bad1c96aebfe886e895ba156f4909cf3367f"
    "387186e9a7b5f6b76fd9fe80ef61e4d1087f94df57eb32a7d481601c14ee54be7f5abb39c2ca33f32db49b6bb5d9bb2e68e759e4ef245e703b0e242b47fe746a",
    "bb1d8b262aa91648670ec397de05da174070607409c96c7f59cb70e00dcf7deee1405be14e65ae6a7c762c0e98d66e8a63e441be857633a4363be381abdf57fe"
    "40e201b7e340b3a4a5d6fdeb7921bf564c06cb7ecf46058417683d10c181d1252493fded1c5ee3c0af30ed4daab7f730f268848fe000ab01be129065f6222ab0",
    "aaca49bc54ebfd9d5bf70d3f1b230ff22db19f51dab3df8ebaff2d115c703b2e5c2676bda1c36651cc96d29540b1ba9bec886992275a4e5ca08e2c8b0fdec1c8"
    "a311fea8f8a053016a7bc0776a3e795eef91b8c56e7a6a73e01e09721fc00ce5d985039aaf59281c6dc7fd92e745309a0e868f1b179b244fb48cefb34e3fb60c",
    "07c87d00b7cb23f701b8d32fdb2d8fdc07604dfb0407469790ccf6b763d97aa1b731f268848f8b07dc1a0764c73c37e45b6c2f4e9c2b4ae28019cab3cbffb7eb"
    "47ad52b9017241b69d3cc8971ba130cb8588ff5fc2f759a71f9138802271c070bf491ce0ac3c120758d33ec181d125245c1cd0c5b447d60ddd2e0fb64fd60d2d",
    "a65fb65b1e5937644dfbffc07c7f523db298f669846f390e3c2971c63141c36bea879feb0cd36f6bef1dc8907d0514d95730dceff17643f615cc521ed957604d"
    "fb243e185d42329f1717b00c07be839147237c0407e0f8d6d0418fefd6f98203ac3c33df1abb19a86dc8746cc4813f91f328dc8f03a156427bd138cf71ada8b8",
    "1f8e15f97c389d8a121c58bef7d9a055cb70e0bb187934c2bf05077aaf805be38143ac3c33df7abbe9d87c0eddd57bbf69101c98571c98f43ecaf340436a0b19"
    "cf45fe38b5218a47db622817a2080e2cdffb6cd086d3e70cc193f81c8b035e4e296ff1efa5ee7efcfe47647e605efdfea4e37f4faeb6a6a9093f906b75251f65",
    "6bc1689c9c3fbaac7effa74eef1febddeb98e4a5b632e0bb350f646bfef0466b4ee40f8fbea192f5426ec78173712318095e644f385113541f978a7afded059a"
    "27263830ba84348f387060eca31ef01d8e47be72dfb0fbf0e1606857baadf304041f6628cf2e7c108fcbfbdecd4c3eb6df4c6c55c2c996060a75324fb0f4f8e0",
    "d0beb29e47cb086d65de7061dabc5106a9a3fd807ceb70c1d0a29deb4a49bc304b7976e1c16e7eb758cc7bd30535c6a61be7f1bd646de305d95fb0a47860ddfe"
    "827731f268847ffbbd9bee3d87ee748c3cc89ff1bda676ce1f7ffae53d328fe0763c50f6229d48f8f23293e8acfb92eb9e5036b0e65980f5a4ff07833b7546",
    "" };

  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(data, 48088U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/* End of code generation (_coder_isInside_info.c) */
