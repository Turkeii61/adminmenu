import './playerItem.scoped.scss'

export interface PlayerItemProps {
    id: string;
    username: string;
    distance: number;
    health: number;
    armor: number;
    group: string;
}

const playerItem = ({ id, username, distance, health, armor }: PlayerItemProps) => {
    return (
        <div className='item'>
            <svg className='movingState' width="54" height="62" viewBox="0 0 54 62" fill="none" xmlns="http://www.w3.org/2000/svg">
                <g filter="url(#filter0_d_390_771)">
                    <path d="M22.368 27.212L25.573 24.884C25.933 24.6211 26.3705 24.4859 26.816 24.5C27.3594 24.5141 27.8849 24.6969 28.3197 25.023C28.7546 25.3491 29.0772 25.8024 29.243 26.32C29.429 26.9033 29.599 27.297 29.753 27.501C30.2186 28.1215 30.8223 28.6252 31.5162 28.9721C32.2101 29.3191 32.9752 29.4998 33.751 29.5V31.5C32.7185 31.5007 31.6987 31.2727 30.7648 30.8323C29.831 30.3919 29.0063 29.7501 28.35 28.953L27.652 32.909L29.713 34.638L31.936 40.746L30.056 41.43L28.017 35.826L24.627 32.981C24.3486 32.7565 24.1355 32.4614 24.01 32.1265C23.8844 31.7916 23.8509 31.4292 23.913 31.077L24.422 28.192L23.745 28.684L21.618 31.612L20 30.436L22.351 27.2L22.368 27.212ZM28.251 24C27.7206 24 27.2119 23.7893 26.8368 23.4142C26.4617 23.0391 26.251 22.5304 26.251 22C26.251 21.4696 26.4617 20.9609 26.8368 20.5858C27.2119 20.2107 27.7206 20 28.251 20C28.7814 20 29.2901 20.2107 29.6652 20.5858C30.0403 20.9609 30.251 21.4696 30.251 22C30.251 22.5304 30.0403 23.0391 29.6652 23.4142C29.2901 23.7893 28.7814 24 28.251 24ZM25.281 37.181L22.067 41.011L20.535 39.726L23.51 36.18L24.256 34L26.047 35.5L25.281 37.181Z" fill="white" />
                </g>
                <defs>
                    <filter id="filter0_d_390_771" x="0" y="0" width="53.751" height="61.4302" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                        <feFlood flood-opacity="0" result="BackgroundImageFix" />
                        <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha" />
                        <feOffset />
                        <feGaussianBlur stdDeviation="10" />
                        <feComposite in2="hardAlpha" operator="out" />
                        <feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0.5 0" />
                        <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_390_771" />
                        <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_390_771" result="shape" />
                    </filter>
                </defs>
            </svg>
            <div className="playerId">
                <span>#{id}</span>
            </div>
            <span className="username">{username}</span>
            <svg className='isAdmin' width="60" height="64" viewBox="0 0 60 64" fill="none" xmlns="http://www.w3.org/2000/svg">
                <g filter="url(#filter0_d_390_786)">
                    <path d="M30.008 20.0097L30.0027 20L20 25.8839L20.0226 25.924V32.8659H20.0268C20.1119 38.661 24.4495 43.4048 30.0036 44C35.5576 43.4051 39.8955 38.6613 39.9804 32.8659V25.9209L40 25.8864L30.008 20.0097ZM30.0036 40.9622V32.5084H22.986V27.6488L30.0036 23.5214V32.5084H37.017V32.8659H37.0221C36.9393 36.9877 33.9149 40.3855 30.0036 40.9622Z" fill="#FFBE44" />
                </g>
                <defs>
                    <filter id="filter0_d_390_786" x="0" y="0" width="60" height="64" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                        <feFlood flood-opacity="0" result="BackgroundImageFix" />
                        <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha" />
                        <feOffset />
                        <feGaussianBlur stdDeviation="10" />
                        <feComposite in2="hardAlpha" operator="out" />
                        <feColorMatrix type="matrix" values="0 0 0 0 0.266667 0 0 0 0 0.517647 0 0 0 0 1 0 0 0 0.25 0" />
                        <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_390_786" />
                        <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_390_786" result="shape" />
                    </filter>
                </defs>
            </svg>

            <span className="distance">{distance >= 1000 ? `${(distance / 1000).toFixed(2)}km` : `${distance}m`}</span>

            <div className="armor">
                <div className="value" style={{ width: `${armor}%` }}></div>
            </div>

            <div className="health" style={{ background: health <= 25 ? 'rgba(255, 0, 0, 0.15)' : '' }}>
                <div className="value" style={{ width: `${health}%`, background: health <= 25 ? '#FF4545' : '', boxShadow: health <= 25 ? '0vmin 0vmin 0.463vmin rgba(235, 255, 0, 0.3)' : '' }}></div>
            </div>
        </div>
    )
}

export default playerItem