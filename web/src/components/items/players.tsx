import React, {useState} from 'react'
import './players.scoped.scss'
import PlayerItem, { PlayerItemProps } from '../playerItem'
import { fetchNui } from '@/lib';

interface PlayersProps {
    players: PlayerItemProps[];
    serverName: string;
}

const Players: React.FC<PlayersProps> = ({ players, serverName }) => {
    
    const [selectedPlayer, setSelectedPlayer] = useState<PlayerItemProps | null>(null);

    const OpenPlayerModal = (player: PlayerItemProps) => {
        setSelectedPlayer(player);
    };

    const CloseModal = () => {
        setSelectedPlayer(null);
    };


    const HandleAction = (action: string) => {
        if (selectedPlayer) {
            const Jsondata = JSON.stringify({
                aktion: action,
                playerid: selectedPlayer.id
            });

            fetchNui('adminpanel:player:send:action', {
                data: Jsondata
            });
        }
    };

    return (
        <div className='playersContainer'>
            <div className="title">
                <span className="servername">{`${serverName}`}</span>
                <span className="players">{`${players.length}/500 Spieler`}</span>
            </div>
            <div className="playersList">
                {/*players?.map((player) => (
                    <PlayerItem {...player} />
                ))*/}
                {/*Array.from({ length: 1 }).map((_, i) => (
                    <PlayerItem armor={100} distance={100} group='Admin' health={100} id='1' username='Marc Abi' key={i} />
                ))*/}
                {players.map((player, index) => (
                    <div key={index} onClick={() => OpenPlayerModal(player)}>
                        <PlayerItem
                            key = {index}
                            id = {player.id}
                            username = {player.username}
                            group = {player.group}
                            health = {player.health ?? 0}
                            armor = {player.armor}
                            distance = {player.distance}    
                        />
                    </div>
                ))}
            </div>

            {/* POPUP MODAL WAS SICH ÖFFNET WENN MAN AUF EIN SPIELER KLICKT */}
            {selectedPlayer && (
                <div className='popup'>
                    <div className='popup-content'>
                        <h3>Spieler: {selectedPlayer.username} ({selectedPlayer.id})</h3>
                        <button onClick={() => HandleAction("revive")}>Revive</button>
                        <button onClick={() => HandleAction("goto")}>Goto</button>
                        <button onClick={() => HandleAction("bring")}>Bring</button>
                        <button onClick={() => HandleAction("freeze")}>Freeze</button>
                        <button onClick={() => HandleAction("charreset")}>Charreset</button>
                        <button onClick={() => HandleAction("skinchanger")}>Skinmenu</button>
                        <button onClick={() => HandleAction("support")}>Support rufen</button>
                        <button onClick={CloseModal}>Schließen</button>
                    </div>
                </div>
            )}
        </div>
    )
}




export default Players