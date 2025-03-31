export const playSound = (sound: string) => {
    const audio = new Audio(`./assets/sounds/${sound}.mp3`);
    audio.volume = 0.1;
    audio.play();
};