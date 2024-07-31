import React, { useState, useEffect, useRef  } from 'react';

const DebounceInput = () => {
    const [inputValue, setInputValue] = useState('');
    const debounceTimeout = useRef(null);

    const handleInputChange = (e) => {
        const value = e.target.value.replace(/,/g, '');
        if (/^[0-9]*\.?[0-9]*$/.test(value)) {
            setInputValue(value);
            debouncedFetchData(value);
        }
    };

    const fetchData = async (value) => {
        // Логика запроса к бэкэнду
        console.log(`Fetching data for: ${value}`);
    };

    const debouncedFetchData = (value) => {
        if (debounceTimeout.current) {
            clearTimeout(debounceTimeout.current);
        }
        debounceTimeout.current = setTimeout(() => {
            fetchData(value);
        }, 3000);
    };

    const formatNumber = (value) => {
        if (!value) return '';
        const parts = value.split('.');
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        return parts.join('.');
    };

    const handleBlur = () => {
        setInputValue(formatNumber(inputValue));
    };

    return (
        <div>
            <input
                type="text"
                value={formatNumber(inputValue)}
                onChange={handleInputChange}
                onBlur={handleBlur}
                placeholder="Введите число"
            />
        </div>
    );
};

export default DebounceInput;
