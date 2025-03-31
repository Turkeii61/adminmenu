import React, { CSSProperties } from 'react'
import './Adminitem.scoped.scss'
import { LucideProps } from 'lucide-react';
import { CSSTransition } from 'react-transition-group';

export type ItemType = 'button' | 'checkbox' | 'separator' | 'list' | 'slider' | 'submenu'

export interface BaseProps {
    id?: string;
    selected?: boolean;
    type: ItemType;
    label: string;
    rightLabel?: string;
    description?: string;
    disabled?: boolean;
    visible?: boolean;
    values?: string[];
    checked?: boolean;
    current?: number;
    IconComponent?: React.ForwardRefExoticComponent<Omit<LucideProps, "ref"> & React.RefAttributes<SVGSVGElement>>;
    iconStyle?: 'cross' | 'tick';
    max?: number;
    min?: number;
}

export interface ButtonProps extends BaseProps {
    type: 'button';
}

export interface SubmenuProps extends BaseProps {
    type: 'submenu';
    items: ItemProps[];
    style?: CSSProperties;
}

export interface CheckboxProps extends BaseProps {
    type: 'checkbox';
}

export interface SeparatorProps extends BaseProps {
    type: 'separator';
}

export interface ListProps extends BaseProps {
    type: 'list';
    values: string[];
    current: number;
}

export interface SliderProps extends BaseProps {
    type: 'slider';
    current: number;
    max: number;
    min?: number;
    step?: number;
}

export type ItemProps =
    | ButtonProps
    | CheckboxProps
    | SeparatorProps
    | ListProps
    | SubmenuProps
    | SliderProps;

const Adminitem = ({
    selected = false,
    type,
    label,
    checked = false,
    current = 0,
    max,
    IconComponent,
    // ...props
}: React.HTMLAttributes<HTMLElement> & ItemProps) => {

    return (
        <div className={`item ${selected ? 'selected' : ''}`}>
            <div className="bar"></div>
            {IconComponent && <IconComponent className='icon' size={18} />}
            {/* <Shield className='icon' size={18} /> */}
            <span>{label}</span>
            {type == 'submenu' && <>
                <svg className='arrow' width="10" height="14" viewBox="0 0 10 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <CSSTransition
                        in={selected}
                        timeout={300}
                        classNames="fade"
                        unmountOnExit>
                        <path d="M1.01742 11.924C1.01699 12.1149 1.05883 12.3024 1.13851 12.4667C1.2182 12.6311 1.33279 12.7662 1.47021 12.8578C1.60258 12.951 1.75274 13 1.90559 13C2.05844 13 2.2086 12.951 2.34097 12.8578L8.6017 7.87018C8.72391 7.77398 8.82439 7.64199 8.89397 7.48628C8.96355 7.33056 9 7.15608 9 6.97878C9 6.80147 8.96355 6.62699 8.89397 6.47128C8.82439 6.31556 8.72391 6.18357 8.6017 6.08737L2.32355 1.14217C2.19118 1.04903 2.04102 1 1.88817 1C1.73532 1 1.58517 1.04903 1.4528 1.14217C1.31538 1.23381 1.20079 1.36892 1.1211 1.53327C1.04141 1.69762 0.999576 1.88513 1 2.07603L1.01742 11.924Z" stroke="#FFBB00" stroke-linecap="round" stroke-linejoin="round" />
                    </CSSTransition>
                    <CSSTransition
                        in={!selected}
                        timeout={300}
                        classNames="fade"
                        unmountOnExit
                    >
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M7.60922 5.12859L1.35433 0.143521C1.03755 -0.0863465 0.651967 -0.0244947 0.373581 0.218297C0.260517 0.313667 0.168006 0.437807 0.10322 0.58109C0.0384341 0.724373 0.00311463 0.882951 0 1.04453L0 10.927C0 11.743 0.783161 12.2711 1.35433 11.8538L7.61002 6.89922C8.12999 6.49395 8.12999 5.53294 7.61002 5.12767L7.60922 5.12859Z" fill="white" fill-opacity="0.3" />
                    </CSSTransition>
                </svg>
            </>}
            {type == 'slider' && <>
                <div className="slider">
                    <div className="value" style={{ width: `${(current / max) * 100}%` }}></div>
                </div>
            </>}
            {type === 'checkbox' && <>
                <CSSTransition
                    in={checked}
                    timeout={300}
                    classNames="fade"
                    unmountOnExit>
                    <svg className='checkbox' width="36" height="36" viewBox="0 0 96 96" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <g filter="url(#filter0_d_390_664)">
                            <path d="M48 30C38.046 30 30 38.046 30 48C30 57.954 38.046 66 48 66C57.954 66 66 57.954 66 48C66 38.046 57.954 30 48 30Z" fill="#9B6B1E" fill-opacity="0.22" shape-rendering="crispEdges" />
                        </g>
                        <defs>
                            <filter id="filter0_d_390_664" x="0" y="0" width="96" height="96" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                                <feFlood flood-opacity="0" result="BackgroundImageFix" />
                                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha" />
                                <feOffset />
                                <feGaussianBlur stdDeviation="15" />
                                <feComposite in2="hardAlpha" operator="out" />
                                <feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.65 0 0 0 0 0 0 0 0 0.3 0" />
                                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_390_664" />
                                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_390_664" result="shape" />
                            </filter>
                        </defs>
                    </svg>
                </CSSTransition>
                <CSSTransition
                    in={checked}
                    timeout={300}
                    classNames="fade"
                    unmountOnExit>
                    <svg className='checked' width="10" height="10" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <g filter="url(#filter0_i_390_665)">
                            <path d="M5 0C2.235 0 0 2.235 0 5C0 7.765 2.235 10 5 10C7.765 10 10 7.765 10 5C10 2.235 7.765 0 5 0Z" fill="#9B7E1E" />
                        </g>
                        <defs>
                            <filter id="filter0_i_390_665" x="0" y="0" width="10" height="10" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                                <feFlood flood-opacity="0" result="BackgroundImageFix" />
                                <feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
                                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha" />
                                <feOffset />
                                <feGaussianBlur stdDeviation="20" />
                                <feComposite in2="hardAlpha" operator="arithmetic" k2="-1" k3="1" />
                                <feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.683333 0 0 0 0 0 0 0 0 0.3 0" />
                                <feBlend mode="normal" in2="shape" result="effect1_innerShadow_390_665" />
                            </filter>
                        </defs>
                    </svg>
                </CSSTransition>

                <CSSTransition
                    in={!checked}
                    timeout={300}
                    classNames="fade"
                    unmountOnExit>
                    <svg className='checkbox' width="36" height="36" viewBox="0 0 96 96" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <g filter="url(#filter0_d_390_674)">
                            <path d="M48 30C38.046 30 30 38.046 30 48C30 57.954 38.046 66 48 66C57.954 66 66 57.954 66 48C66 38.046 57.954 30 48 30Z" fill="#9B821E" fill-opacity="0.2" shape-rendering="crispEdges" />
                        </g>
                        <defs>
                            <filter id="filter0_d_390_674" x="0" y="0" width="96" height="96" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
                                <feFlood flood-opacity="0" result="BackgroundImageFix" />
                                <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha" />
                                <feOffset />
                                <feGaussianBlur stdDeviation="15" />
                                <feComposite in2="hardAlpha" operator="out" />
                                <feColorMatrix type="matrix" values="0 0 0 0 1 0 0 0 0 0.65 0 0 0 0 0 0 0 0 0.3 0" />
                                <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_390_674" />
                                <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_390_674" result="shape" />
                            </filter>
                        </defs>
                    </svg>
                </CSSTransition>
                <CSSTransition in={!checked}
                    timeout={300}
                    classNames="fade"
                    unmountOnExit>
                    <svg className='checked' width="10" height="10" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M5 0C2.235 0 0 2.235 0 5C0 7.765 2.235 10 5 10C7.765 10 10 7.765 10 5C10 2.235 7.765 0 5 0Z" fill="#9B6F1E" fill-opacity="0.4" />
                    </svg>
                </CSSTransition>
            </>}
        </div>
    )
}

export default Adminitem