import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const EtherStakingModule = buildModule("EtherStaking", (m) => {
  

  const EtherStaking = m.contract("EtherStaking");

  return { EtherStaking };
});

export default EtherStakingModule;


//EtherStaking#EtherStaking - 0xf4784673960dc8887BA6A07EFD90534B6316EaDA