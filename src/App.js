import React, {useState} from "react";
import { ApiRequest } from "./apiRequest";

export default function App() {
  const request = new ApiRequest("192.168.1.10");
  const [tempMax, setTempMax] = useState(request.getTempMax());
  const [tempMin, setTempMin] = useState(request.getTempMin());
  const [tempMoy, setTempMoy] = useState(request.getTempMoy());
  const [soundMax, setSoundMax] = useState(request.getSoundMax());
  const [soundMin, setSoundMin] = useState(request.getSoundMin());
  const [soundMoy, setSoundMoy] = useState(request.getSoundMoy());

  function getNextData() {
    setTempMax(request.getTempMax());
    setTempMin(request.getTempMin());
    setTempMoy(request.getTempMoy());
    setSoundMax(request.getSoundMax());
    setSoundMin(request.getSoundMin());
    setSoundMoy(request.getSoundMoy());
  }

  return (
        <div id="app">
          <p id="id_temp_max">Température maximale : {tempMax} °C</p>
          <p id="id_temp_min">Température minimale : {tempMin} °C</p>
          <p id="id_temp_moy">Température moyenne : {tempMoy} °C</p>
          <p id="id_sound_max">Niveau sonore maximale : {soundMax} dB</p>
          <p id="id_sound_min">Niveau sonore minimale : {soundMin} dB</p>
          <p id="id_sound_moy">Niveau sonore moyen : {soundMoy} dB</p>
          <button id="btn_reset"onClick={() => getNextData()}> Saisir prochaines valeurs</button>
        </div>
    );
};

