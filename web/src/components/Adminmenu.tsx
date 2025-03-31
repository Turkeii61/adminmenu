import { useCallback, useEffect, useState } from 'react';
import './Adminmenu.scoped.scss';
import { useKeyDown } from '@/lib/keys';
import Item, { SubmenuProps, type ItemProps } from '@/components/Adminitem';
import { Axe, Ban, Bomb, Box, CarFront, CircleAlert, CodeXml, CupSoda, Delete, DollarSign, Eraser, EyeOff, Fence, Key, MapPin, Mountain, Rabbit, RefreshCcw, Rocket, ScanFace, Send, Shield, User, Wrench, Zap, ZapOff } from 'lucide-react';
import Submenu from './items/submenu';
import { CSSTransition } from 'react-transition-group';
import Players from './items/players';
import { PlayerItemProps } from './playerItem';
import { useNuiEvent } from '@/lib/hooks';
import { fetchNui } from '@/lib';

export interface MenuProps {
    id: string;
    resource: string;
    maxVisibleItems?: number;
    banner?: string;
}

export const icons = {
    'Key': Key,
    'Shield': Shield,
    'ScanFace': ScanFace,
    'EyeOff': EyeOff,
    'Ban': Ban,
    'MapPin': MapPin,
    'Car': CarFront,
    'Code': CodeXml,
    'Rabbit': Rabbit,
    'Axe': Axe,
    'Eraser': Eraser,
    'Send': Send,
    'Alert': CircleAlert,
    'Rocket': Rocket,
    'Delete': Delete,
    'Repair': Wrench,
    'Flip': RefreshCcw,
    'Bomb': Bomb,
    'Cup': CupSoda,
    'Mountain': Mountain,
    'User': User,
    'Fence': Fence,
    'Cash': DollarSign,
    'Box': Box,
    'Flash': Zap,
    'FlashOff': ZapOff,
};

const Adminmenu = () => {
    const [activeTab, setActiveTab] = useState('admin');
    const [items, setItems] = useState<ItemProps[]>([]);
    const [state, setState] = useState(false);
    const [players, setPlayers] = useState<PlayerItemProps[]>([]);
    const [serverName, setServerName] = useState("not Loaded");
    const [selected, setSelected] = useState(0);
    const [submenuSelected, setSubmenuSelected] = useState(false);
    const [menu, setMenu] = useState<MenuProps | undefined>({
        id: 'adminmenu',
        resource: 'adminmenu',
        maxVisibleItems: 10,
        banner: 'https://r2.e-z.host/14b557b1-a7d1-4e5a-9c80-4f3a08eb5dd7/e2i62x9x.png'
    });

      

    useNuiEvent<MenuProps>('updateMenu', (menuProps) => {
        setMenu((prevMenu) => {
            if (!prevMenu) return menuProps;

            return {
                ...prevMenu,
                ...menuProps
            };
        });
    });


    useNuiEvent<{ serverName: string }>('updateServerName', (data) => {
        setServerName(data.serverName);
    });
    
    useNuiEvent<MenuProps | undefined>('setMenu', (_menu) => {
        setMenu(_menu);
    });

    useNuiEvent<ItemProps[]>('setItems', (item) => {
        if (!item) return;
        item.forEach((i) => {
            i.IconComponent = icons[i.IconComponent as unknown as keyof typeof icons];
            if (i.type === 'submenu') {
                i.items?.forEach((i1) => {
                    i1.IconComponent = icons[i1.IconComponent as unknown as keyof typeof icons];
                });
            }
        });
        setItems(item);
    });

    useNuiEvent<ItemProps>('addItem', (item) => {
        item.IconComponent = icons[item.IconComponent as unknown as keyof typeof icons];
        if (item.type === 'submenu') {
            item.items?.forEach((i) => {
                i.IconComponent = icons[i.IconComponent as unknown as keyof typeof icons];
            });
        }
        setItems([...items, item]);
    });

    useNuiEvent('addItems', (items1) => {
        items1.forEach((i: ItemProps) => {
            i.IconComponent = icons[i.IconComponent as unknown as keyof typeof icons];
            if (i.type === 'submenu') {
                i.items?.forEach((i1) => {
                    i1.IconComponent = icons[i1.IconComponent as unknown as keyof typeof icons];
                });
            }
        });
        setItems([...items, ...items1]);
    });

    useNuiEvent('updateItems', (items1) => {
        items1.forEach((i: ItemProps) => {
            const index = items.findIndex((i1) => i1.id === i.id);

            if (index === -1) return;

            items[index] = {
                ...items[index],
                ...i
            };
        });

        setItems([...items]);
    })

    useNuiEvent<string>('removeItem', (id) => {
        setItems((items) => items.filter((i) => i.id !== id));
    });

    useNuiEvent<ItemProps>('updateItem', (item) => {
        const index = items.findIndex((i) => i.id === item.id);

        if (index === -1) return;

        items[index] = {
            ...items[index],
            ...item
        };

        setItems([...items]);
    });
    //#endregion

    useEffect(() => {
        if (!menu || !items || !items[selected]) return;

        fetchNui('OnSelect', {
            menu,
            selected: items[selected].id
        });
    }, [selected, menu, items]);

    //#region keys
    useKeyDown('Tab', () => {
        if (state) {
            if (activeTab == 'players') {
                setActiveTab('admin');
                fetchNui('nuiFocus', {
                    focus: true,
                    cursor: false,
                    input: true
                });
            } else {
                setActiveTab('players');
                setSubmenuSelected(false);
                fetchNui('nuiFocus', {
                    focus: true,
                    cursor: true,
                    input: false
                });
            }
        }
    });

    const findNextValidIndex = useCallback(
        (direction: 'up' | 'down') => {
            const step = direction === 'up' ? -1 : 1;
            let index = selected;
            do {
                index += step;
                if (index < 0) index = items.length - 1;
                if (index >= items.length) index = 0;

                if (items[index].type !== 'separator' && !items[index].disabled && items[index].visible !== false) {
                    return index;
                }
            } while (index !== selected);

            return -1;
        },
        [items, selected]
    );

    useKeyDown('ArrowUp', () => {
        if (submenuSelected) return;
        const newIndex = findNextValidIndex('up');
        setSelected(newIndex);
    });

    useKeyDown('ArrowDown', () => {
        if (submenuSelected) return;
        const newIndex = findNextValidIndex('down');
        setSelected(newIndex);
    });

    useKeyDown('ArrowRight', () => {
        const item = items[selected];

        if (item.type === 'separator' || item.disabled || item.visible === false) return;

        if (item.type === 'list') {
            if (item.current === item.values.length - 1) item.current = 0;
            else item.current++;
        } else if (item.type === 'slider') {
            if (item.current === item.max) return;

            item.current += Math.min(item.step ?? 1, item.max);
        }

        setItems([...items]);
    });

    useKeyDown('ArrowLeft', () => {
        const item = items[selected];

        if (item.type === 'separator' || item.disabled || item.visible === false) return;

        if (item.type === 'list') {
            if (item.current === 0) item.current = item.values.length - 1;
            else item.current--;
        } else if (item.type === 'slider') {
            if (item.current === (item.min ?? 0)) return;

            item.current -= Math.max(item.step ?? 1, item.min ?? 0);
        }

        setItems([...items]);
    });

    useKeyDown('Enter', async () => {
        const item = items[selected];

        if (item.type === 'separator' || item.disabled || item.visible === false) return;

        if (item.type === 'checkbox') {
            item.checked = !item.checked;

            await fetchNui('onChange', {
                selected: JSON.stringify(items[selected].id)
            });
        }
        if (item.type === 'submenu') {
            setSubmenuSelected(true);
            setSelected(selected);
        }
    });

    const [cooldown, setCooldown] = useState(false);
    useKeyDown('Backspace', () => {
        if (state) {
            if (submenuSelected) {
                setSubmenuSelected(false);
                setCooldown(true);
                setTimeout(() => setCooldown(false), 400);
            } else {
                if (activeTab === 'admin') {
                    if (cooldown) return;
                    setState(false);
                    setItems([]);
                    setSelected(0);
                    fetchNui('Exit', { menu: menu });
                    fetchNui('closeAdminpanel')
                    // fetchNui('nuiFocus', { focus: false, cursor: false, input: false })
                }
            }
        }
    });

    useKeyDown('Escape', () => {
        if (state) {
            if (activeTab === 'players') {
                setState(false);
                setItems([]);
                setSelected(0);
                fetchNui('Exit', { menu: menu });
                fetchNui('closeAdminpanel')
                fetchNui('nuiFocus', { focus: false, cursor: false, input: false });
            }
        }
    });
    //#endregion

    useNuiEvent('toggleAdminpanel', (data) => {
        setState(data.state);
    });

    // Updating Player List
    window.addEventListener("message", (event: any) => {
        if (event.data.type === "updatePlayersList") {
            setPlayers(event.data.players);
        }
    });

    const switchToAdmin = () => {
        if (state) {
            setActiveTab('admin');
            fetchNui('nuiFocus', {
                focus: true,
                cursor: false,
                input: true
            });
        }
    };

    const switchToPlayers = () => {
        if (state) {
            setActiveTab('players');
            setSubmenuSelected(false);
            fetchNui('nuiFocus', {
                focus: true,
                cursor: true,
                input: false
            });
        }
    };

    return (
        <CSSTransition in={state} timeout={200} classNames="fade" unmountOnExit>
            <div>
                <div>
                    <div className="container">
                        <div className="banner">
                            <img src={menu?.banner} />
                        </div>
                        {/* <svg className="border" width="247" height="382" viewBox="0 0 247 382" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <rect x="0.5" y="0.5" width="246" height="381" stroke="url(#paint0_linear_390_662)" stroke-opacity="0.3" />
                            <defs>
                                <linearGradient id="paint0_linear_390_662" x1="123.5" y1="0" x2="123.5" y2="382" gradientUnits="userSpaceOnUse">
                                    <stop stop-color="#DFDFDF" stop-opacity="0" />
                                    <stop offset="0.52" stop-color="#ABABAB" stop-opacity="0" />
                                    <stop offset="0.765" stop-color="white" stop-opacity="0.37" />
                                    <stop offset="1" stop-color="white" stop-opacity="0.5" />
                                </linearGradient>
                            </defs>
                        </svg> */}
                        <div className="tabs">
                            <div className={`tab ${activeTab == 'admin' ? 'active' : ''}`} onClick={switchToAdmin}>
                                <span>Admin</span>
                            </div>
                            {<div className={`tab ${activeTab == 'players' ? 'active' : ''}`} onClick={switchToPlayers}>
                                <span>Spieler</span>
                            </div>}
                        </div>
                    </div>
                    <div
                        className={`container2 ${activeTab == 'admin' ? 'admin' : 'players'}`}
                        style={{
                            width: activeTab === 'players' ? '157.2222vmin' : '',
                            height: activeTab === 'players' ? '76.0185vmin' : ''
                        }}
                    >
                       <CSSTransition in={activeTab === 'admin'} timeout={200} classNames="tab-slide" unmountOnExit>
                            <div className="items">
                                {items &&
                                    items.length > 0 &&
                                    items.map((item, index) => (
                                        <Item
                                            key={index}
                                            {...item}
                                            selected={index === selected}
                                            
                                        />
                                    ))}
                            </div>
                        </CSSTransition>

                        <CSSTransition
                            in={activeTab === 'players'}
                            timeout={{ enter: 400, exit: 200 }} // Added delay for enter transition
                            classNames="tab-slide"
                            unmountOnExit
                        >
                        <Players players={players} serverName={serverName} />
                                    
                        </CSSTransition>
                    </div>
                    {
                        <CSSTransition
                            in={items[selected]?.type === 'submenu' && submenuSelected && activeTab === 'admin'}
                            timeout={200}
                            classNames="submenu-slide"
                            unmountOnExit
                        >
                            {items[selected]?.type === 'submenu' && (
                                <Submenu
                                    {...(items[selected] as SubmenuProps)}
                                    style={{ top: `${0.09259259259259259 * (133 + 38 * selected)}vmin` }}
                                />
                            )}
                        </CSSTransition>
                    }
                </div>
            </div>
        </CSSTransition>
    );
};

export default Adminmenu;
