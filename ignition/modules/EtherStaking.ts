import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const EtherSatkingModule = buildModule("EtherSatking", (m) => {
  

  const EtherSatking = m.contract("EtherSatking");

  return { EtherSatking };
});

export default EtherSatkingModule;

//EtherSatking#EtherSatking - 0xF38f6b9b07E9031fACB2fc77EeE6C97dfd796Db0
