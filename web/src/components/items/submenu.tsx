import { useCallback, useEffect, useState } from 'react'
import './submenu.scoped.scss'
import Adminitem, { SubmenuProps } from '../Adminitem'
import { useKeyDown } from '@/lib/keys';

import { CSSProperties } from 'react';
import { fetchNui } from '@/lib';

const Submenu = ({ items, style }: SubmenuProps & { style?: CSSProperties }) => {
    const [selected, setSelected] = useState(0)
    const [newItems, setItems] = useState(items)

    const findNextValidIndex = useCallback(
        (direction: 'up' | 'down') => {
            const step = direction === 'up' ? -1 : 1;
            let index = selected;
            do {
                index += step;
                if (index < 0) index = newItems.length - 1;
                if (index >= newItems.length) index = 0;
                if (!newItems[index]) return -1;
                if (
                    newItems[index].type !== 'separator' &&
                    !newItems[index].disabled &&
                    newItems[index].visible !== false
                ) {
                    return index;
                }
            } while (index !== selected);

            return -1;
        },
        [newItems, selected]
    );

    useKeyDown('ArrowUp', () => {
        const newIndex = findNextValidIndex('up');
        if (newIndex !== -1) {
            setSelected(newIndex);
        }
    });
    
    useKeyDown('ArrowDown', () => {
        const newIndex = findNextValidIndex('down');
        if (newIndex !== -1) {
            setSelected(newIndex);
        }
    });
    
    useKeyDown('ArrowRight', () => {
        const item = newItems[selected]

        if (item.type === 'separator' || item.disabled || item.visible === false)
            return

        if (item.type === 'list') {
            if (item.current === item.values.length - 1) item.current = 0;
            else item.current++;
        } else if (item.type === 'slider') {
            if (item.current === item.max) return;

            item.current += Math.min(item.step ?? 1, item.max);
        }

        setItems([...newItems]);
    })

    useKeyDown('ArrowLeft', () => {
        const item = newItems[selected];

        if (item.type === 'separator' || item.disabled || item.visible === false)
            return;

        if (item.type === 'list') {
            if (item.current === 0) item.current = item.values.length - 1;
            else item.current--;
        } else if (item.type === 'slider') {
            if (item.current === (item.min ?? 0)) return;

            item.current -= Math.max(item.step ?? 1, item.min ?? 0);
        }

        setItems([...newItems]);
    })

    useEffect(() => {
        if (!items || !items[selected]) return;

        fetchNui('OnSelect', {
            selected: items[selected].id
        });
    }, [selected, items]);

    useKeyDown('Enter', () => {
        const item = newItems[selected];

        if (item.type === 'separator' || item.disabled || item.visible === false)
            return;

        if (item.type === 'checkbox') {
            item.checked = !item.checked;

            fetchNui('onChange', {
                selected: items[selected].id,
            });

            return setItems([...newItems]);
        }
        if (item.type === 'button') {
            fetchNui('onClick', {
                selected: items[selected].id,
            });
            
        }
    })

    return (
        <div className={`submenu`} style={style || undefined}>
            {/* <svg className='border' width="247" height="312" viewBox="0 0 247 312" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="0.5" y="0.5" width="246" height="311" stroke="url(#paint0_linear_390_663)" stroke-opacity="0.3" />
                <defs>
                    <linearGradient id="paint0_linear_390_663" x1="123.5" y1="0" x2="123.5" y2="312" gradientUnits="userSpaceOnUse">
                        <stop stop-color="#DFDFDF" stop-opacity="0" />
                        <stop offset="0.52" stop-color="#ABABAB" stop-opacity="0" />
                        <stop offset="0.765" stop-color="white" stop-opacity="0.37" />
                        <stop offset="1" stop-color="white" stop-opacity="0.5" />
                    </linearGradient>
                </defs>
            </svg> */}
            <div className="items">
                {items.map((item, index) => (
                    <Adminitem key={index} {...item} selected={index == selected} />
                ))}
            </div>
        </div>
    )
}

export default Submenu