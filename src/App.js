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
            <div id="content">
                <div className="table">
                    <p className="table_title">Température</p>
                    <div>
                        <p className="data">Maximale : {tempMax} °C</p>
                        <p className="data">Minimale : {tempMin} °C</p>
                        <p className="data">Moyenne : {tempMoy} °C</p>
                    </div>
                </div>
                <div className="table">
                    <p className="table_title">Niveau sonore</p>
                    <div>
                        <p className="data">Maximale : {soundMax} dB</p>
                        <p className="data">Minimale : {soundMin} dB</p>
                        <p className="data">Moyen : {soundMoy} dB</p>
                    </div>
                </div>
            </div>



          <button id="btn_reset"onClick={() => getNextData()}> Saisir prochaines valeurs</button>
        </div>
    );
};

