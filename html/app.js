const isFiveM = typeof GetParentResourceName === 'function';

const ACTIONS = [
    { id: 'toggle', label: 'Call' },
    { id: 'pet', label: 'Pet' },
    { id: 'feed', label: 'Feed' },
    { id: 'water', label: 'Water' },
    { id: 'walk', label: 'Walk' },
    { id: 'unwalk', label: 'Stop' },
    { id: 'sit', label: 'Sit' },
    { id: 'stay', label: 'Stay' },
    { id: 'follow', label: 'Follow' },
    { id: 'attack', label: 'Attack' },
    { id: 'collar', label: 'Collar' },
    { id: 'revive', label: 'Revive' },
    { id: 'rename', label: 'Rename' },
];

const ICONS = {
    toggle: '<svg viewBox="0 0 24 24"><path d="M8 7h8M8 12h8M8 17h5"/></svg>',
    pet: '<svg viewBox="0 0 24 24"><path d="M7 13c0-2 1.5-3 3-3s3 1 5 1 3-1 3-1-1 6-5 6-6-2-6-3z"/><circle cx="8" cy="8" r="1.2"/><circle cx="12" cy="6.5" r="1.2"/><circle cx="16" cy="8" r="1.2"/></svg>',
    feed: '<svg viewBox="0 0 24 24"><path d="M5 14c0-4 3-7 7-7s7 3 7 7v2H5z"/><path d="M8 18h8"/></svg>',
    water: '<svg viewBox="0 0 24 24"><path d="M12 4s6 7 6 11a6 6 0 1 1-12 0c0-4 6-11 6-11z"/></svg>',
    walk: '<svg viewBox="0 0 24 24"><circle cx="12" cy="5" r="2"/><path d="M9 22l2-8 3 2 2 6M9 10l3 2 4-3"/></svg>',
    unwalk: '<svg viewBox="0 0 24 24"><path d="M6 6l12 12M18 6L6 18"/></svg>',
    sit: '<svg viewBox="0 0 24 24"><path d="M5 20V10h4v10M13 20V8h6"/></svg>',
    stay: '<svg viewBox="0 0 24 24"><rect x="7" y="7" width="10" height="10" rx="1"/></svg>',
    follow: '<svg viewBox="0 0 24 24"><path d="M5 12h14M13 6l6 6-6 6"/></svg>',
    attack: '<svg viewBox="0 0 24 24"><path d="M12 3l2 6 6 .5-4.5 4 1.5 6L12 16l-5 3.5 1.5-6L4 9.5 10 9z"/></svg>',
    collar: '<svg viewBox="0 0 24 24"><ellipse cx="12" cy="12" rx="8" ry="5"/><circle cx="18" cy="12" r="1.5"/></svg>',
    revive: '<svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>',
    rename: '<svg viewBox="0 0 24 24"><path d="M4 20h4l10-10-4-4L4 16z"/></svg>',
};

const MOCK = {
    selected: 'demo-1',
    spawnedPetId: 'demo-1',
    walking: true,
    supplies: { food: 4, water: 3, collar: 1, leash: 1, revive: 1 },
    pets: [
        {
            petId: 'demo-1',
            name: 'Brass',
            species: 'pet_cane',
            speciesLabel: 'Cane Corso',
            category: 'dogs',
            rarity: 'rare',
            image: 'images/pet_cane.png',
            canAttack: true,
            dead: false,
            collar: true,
            spawned: true,
            walking: true,
            sitting: false,
            health: 86,
            hunger: 62,
            thirst: 54,
            happiness: 78,
            bond: 40,
            level: 3,
            ageDays: 12,
        },
        {
            petId: 'demo-2',
            name: 'Miso',
            species: 'pet_sphynx',
            speciesLabel: 'Sphynx',
            category: 'cats',
            rarity: 'rare',
            image: 'images/pet_sphynx.png',
            canAttack: false,
            dead: false,
            collar: false,
            spawned: false,
            walking: false,
            sitting: false,
            health: 100,
            hunger: 90,
            thirst: 80,
            happiness: 70,
            bond: 10,
            level: 1,
            ageDays: 2,
        },
        {
            petId: 'demo-3',
            name: 'Ash',
            species: 'pet_husky',
            speciesLabel: 'Husky',
            category: 'dogs',
            rarity: 'uncommon',
            image: 'images/pet_husky.png',
            canAttack: true,
            dead: true,
            collar: true,
            spawned: false,
            walking: false,
            sitting: false,
            health: 0,
            hunger: 0,
            thirst: 0,
            happiness: 0,
            bond: 55,
            level: 2,
            ageDays: 20,
        },
        {
            petId: 'demo-4',
            name: 'Pebble',
            species: 'pet_capybara',
            speciesLabel: 'Capybara',
            category: 'exotic',
            rarity: 'epic',
            image: 'images/pet_capybara.png',
            canAttack: false,
            dead: false,
            collar: true,
            spawned: false,
            walking: false,
            sitting: false,
            health: 94,
            hunger: 70,
            thirst: 66,
            happiness: 88,
            bond: 22,
            level: 2,
            ageDays: 8,
        },
        {
            petId: 'demo-5',
            name: 'Ridge',
            species: 'pet_wolf',
            speciesLabel: 'Wolf',
            category: 'wild',
            rarity: 'epic',
            image: 'images/pet_wolf.png',
            canAttack: true,
            dead: false,
            collar: true,
            spawned: false,
            walking: false,
            sitting: false,
            health: 100,
            hunger: 72,
            thirst: 65,
            happiness: 54,
            bond: 30,
            level: 4,
            ageDays: 16,
        },
    ],
};

const MOCK_CATALOG = {
    shopName: 'Companion Emporium',
    currency: 'money',
    categories: [
        { id: 'dogs', label: 'Dogs' },
        { id: 'puppies', label: 'Puppies' },
        { id: 'cats', label: 'Cats' },
        { id: 'farm', label: 'Farm' },
        { id: 'exotic', label: 'Exotic' },
        { id: 'wild', label: 'Wild' },
        { id: 'special', label: 'Special' },
        { id: 'supplies', label: 'Supplies' },
    ],
    animals: [
        { name: 'pet_cane', label: 'Cane Corso', category: 'dogs', rarity: 'rare', price: 11000, canAttack: true, description: 'An Italian mastiff built like a vault door.', image: 'images/pet_cane.png' },
        { name: 'pet_husky', label: 'Husky', category: 'dogs', rarity: 'uncommon', price: 8750, canAttack: true, description: 'A thick-coated northern working dog.', image: 'images/pet_husky.png' },
        { name: 'pet_sphynx', label: 'Sphynx', category: 'cats', rarity: 'rare', price: 6500, canAttack: false, description: 'Hairless, warm, and wildly affectionate.', image: 'images/pet_sphynx.png' },
        { name: 'pet_capybara', label: 'Capybara', category: 'exotic', rarity: 'epic', price: 16000, canAttack: false, description: 'The world\'s most relaxed roommate.', image: 'images/pet_capybara.png' },
        { name: 'pet_wolf', label: 'Wolf', category: 'wild', rarity: 'epic', price: 17000, canAttack: true, description: 'A timber wolf with a low howl.', image: 'images/pet_wolf.png' },
        { name: 'pet_yorkie', label: 'Yorkshire Terrier Puppy', category: 'puppies', rarity: 'common', price: 3900, canAttack: true, description: 'A silk-haired scrap of confidence.', image: 'images/pet_yorkie.png' },
        { name: 'pet_robot', label: 'Zathura', category: 'special', rarity: 'legendary', price: 25000, canAttack: true, description: 'A compact companion automaton.', image: 'images/pet_robot.png' },
    ],
    supplies: [
        { name: 'pet_food', label: 'Premium Kibble', category: 'supplies', rarity: 'common', price: 25, description: 'Slow-baked kibble.', image: 'images/pet_food.png' },
        { name: 'pet_water', label: 'Fresh Water', category: 'supplies', rarity: 'common', price: 20, description: 'Clean drinking water.', image: 'images/pet_water.png' },
        { name: 'pet_collar', label: 'Leather Collar', category: 'supplies', rarity: 'common', price: 150, description: 'Required before walking.', image: 'images/pet_collar.png' },
        { name: 'pet_leash', label: 'Walking Leash', category: 'supplies', rarity: 'common', price: 125, description: 'Keep this on you to walk.', image: 'images/pet_leash.png' },
        { name: 'pet_revive', label: 'Revive Kit', category: 'supplies', rarity: 'common', price: 750, description: 'Field medicine for a downed pet.', image: 'images/pet_revive.png' },
    ],
};

let state = null;
let selectedId = null;
let catalog = null;
let shopCategory = 'all';
let shopQuery = '';
let shopSelected = null;
let buying = false;

function resourceName() {
    return isFiveM ? GetParentResourceName() : 'djfivem-pets';
}

function nui(name, payload) {
    if (!isFiveM) {
        console.log('[preview nui]', name, payload);
        return Promise.resolve({ ok: true });
    }
    return fetch(`https://${resourceName()}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(payload || {}),
    }).then((res) => res.json()).catch(() => ({ ok: false }));
}

function $(id) {
    return document.getElementById(id);
}

function glyphFor(label) {
    return (label || 'PT').replace(/[^A-Za-z]/g, '').slice(0, 2).toUpperCase() || 'PT';
}

function imageFor(pet) {
    return pet.image || `images/${pet.species}.png`;
}

function rarityLabel(value) {
    return (value || 'companion').replace(/_/g, ' ');
}

function money(value) {
    return `$${Number(value || 0).toLocaleString('en-US')}`;
}

function selectedPet() {
    if (!state) return null;
    return state.pets.find((pet) => pet.petId === selectedId) || state.pets[0];
}

function actionState(action, pet) {
    const out = pet.spawned && !pet.dead;
    const supplies = state.supplies || {};
    switch (action) {
        case 'toggle':
            return pet.dead
                ? { disabled: true, hint: 'Revive this companion first.' }
                : { disabled: false, hint: pet.spawned ? 'Send them home.' : 'Call them to your side.' };
        case 'pet':
            return out ? { disabled: false } : { disabled: true, hint: 'Call your companion first.' };
        case 'feed':
            if (!out) return { disabled: true, hint: 'Call your companion first.' };
            if (!supplies.food) return { disabled: true, hint: 'You need premium kibble.' };
            return { disabled: false };
        case 'water':
            if (!out) return { disabled: true, hint: 'Call your companion first.' };
            if (!supplies.water) return { disabled: true, hint: 'You need fresh water.' };
            return { disabled: false };
        case 'walk':
            if (!out) return { disabled: true, hint: 'Call your companion first.' };
            if (pet.walking) return { disabled: true, hint: 'Already on a walk.' };
            if (!pet.collar) return { disabled: true, hint: 'Fit a collar first.' };
            if (!supplies.leash) return { disabled: true, hint: 'You need a leash in your inventory.' };
            return { disabled: false, hint: 'Collar and leash required.' };
        case 'unwalk':
            return pet.walking ? { disabled: false } : { disabled: true, hint: 'You are not walking this companion.' };
        case 'sit':
        case 'stay':
        case 'follow':
            return out ? { disabled: false } : { disabled: true, hint: 'Call your companion first.' };
        case 'attack':
            if (!pet.canAttack) return { disabled: true, hint: 'This companion cannot attack.' };
            if (!out) return { disabled: true, hint: 'Call your companion first.' };
            return { disabled: false, hint: 'Aim at a target, then send them.' };
        case 'collar':
            if (pet.dead) return { disabled: true, hint: 'Revive them first.' };
            if (!out) return { disabled: true, hint: 'Call your companion first.' };
            if (pet.collar) return { disabled: true, hint: 'Already collared.' };
            if (!supplies.collar) return { disabled: true, hint: 'You need a leather collar.' };
            return { disabled: false };
        case 'revive':
            if (!pet.dead) return { disabled: true, hint: 'This companion is alive.' };
            if (!supplies.revive) return { disabled: true, hint: 'You need a revive kit.' };
            return { disabled: false };
        case 'rename':
            return { disabled: false };
        default:
            return { disabled: true };
    }
}

function applyMenuBox(menu) {
    const root = document.documentElement;
    if (!menu) return;
    if (menu.top) root.style.setProperty('--menu-top', menu.top);
    if (menu.right) root.style.setProperty('--menu-right', menu.right);
    if (menu.width) root.style.setProperty('--menu-width', `${menu.width}px`);
}

function bindImage(img, src, fallbackEl) {
    if (!img) return;
    img.onload = () => {
        img.style.display = 'block';
        if (fallbackEl) fallbackEl.parentElement.classList.add('has-image');
    };
    img.onerror = () => {
        img.removeAttribute('src');
        img.style.display = 'none';
        if (fallbackEl) fallbackEl.parentElement.classList.remove('has-image');
    };
    img.src = src;
}

function renderKennel() {
    const pet = selectedPet();
    const app = $('app');
    if (!pet) {
        app.classList.add('hidden');
        app.setAttribute('aria-hidden', 'true');
        return;
    }

    app.classList.remove('hidden');
    app.setAttribute('aria-hidden', 'false');

    const glyph = glyphFor(pet.speciesLabel || pet.name);
    $('badge').style.background = '';
    $('badge-glyph').textContent = glyph;
    bindImage($('badge-img'), imageFor(pet), $('badge-glyph'));
    $('pet-name').textContent = pet.name;
    $('pet-meta').textContent = pet.speciesLabel;
    $('pet-rarity').textContent = rarityLabel(pet.rarity || pet.category);
    $('pet-level').textContent = pet.dead ? 'Down' : `Lv ${pet.level}`;
    $('age-label').textContent = `${pet.ageDays || 0} day${pet.ageDays === 1 ? '' : 's'} old`;

    $('pet-switcher').innerHTML = state.pets.map((entry) => {
        const active = entry.petId === pet.petId ? 'active' : '';
        const down = entry.dead ? 'down' : '';
        return `
            <button type="button" class="pet-chip ${active} ${down}" data-id="${entry.petId}">
                <img alt="" src="${imageFor(entry)}" onerror="this.replaceWith(Object.assign(document.createElement('div'),{className:'glyph',textContent:'${glyphFor(entry.speciesLabel)}'}))" />
                <span>${entry.name}</span>
            </button>
        `;
    }).join('');

    const segs = [];
    segs.push(`<span class="pill ${pet.dead ? 'dead' : 'live'}">${pet.dead ? 'Down' : 'Alive'}</span>`);
    segs.push(`<span class="pill ${pet.spawned ? 'on' : ''}">${pet.spawned ? 'Out' : 'Home'}</span>`);
    if (pet.collar) segs.push('<span class="pill on">Collar</span>');
    if (pet.walking) segs.push('<span class="pill on">Leash</span>');
    if (pet.canAttack) segs.push('<span class="pill">Guard</span>');
    $('chips').innerHTML = segs.join('');

    const stats = [
        ['Health', pet.health, '#8fbf8a'],
        ['Hunger', pet.hunger, '#e8c36a'],
        ['Thirst', pet.thirst, '#7eb6ff'],
        ['Mood', pet.happiness, '#c89bff'],
    ];
    $('stats').innerHTML = stats.map(([label, value, tone]) => {
        const n = Math.round(value);
        return `
            <article class="metric">
                <div class="ring" style="--value:${n};--tone:${tone}"><strong>${n}</strong></div>
                <p class="metric-label">${label}</p>
            </article>
        `;
    }).join('');

    const bondMax = 100;
    const bond = Math.round(pet.bond || 0);
    $('bond-label').textContent = pet.dead ? 'Recover first' : `Lv ${pet.level} · ${bond}/${bondMax}`;
    $('bond-fill').style.width = `${Math.max(0, Math.min(100, bond))}%`;

    let hint = '';
    $('actions').innerHTML = ACTIONS.map((action) => {
        const info = actionState(action.id, pet);
        if (info.hint && !info.disabled && !hint) hint = info.hint;
        if (info.disabled && info.hint && action.id === 'walk' && !pet.collar) hint = info.hint;
        const primary = action.id === 'toggle' ? 'primary' : '';
        const label = action.id === 'toggle'
            ? (pet.spawned ? 'Home' : 'Call')
            : action.label;
        return `<button type="button" class="${primary}" data-action="${action.id}" ${info.disabled ? 'disabled' : ''} title="${info.hint || ''}">${ICONS[action.id] || ''}${label}</button>`;
    }).join('');
    $('hint').textContent = hint;
}

function applyData(data) {
    state = data;
    if (!selectedId || !data.pets.some((pet) => pet.petId === selectedId)) {
        selectedId = data.selected || (data.pets[0] && data.pets[0].petId);
    }
    renderKennel();
}

function catalogItems() {
    if (!catalog) return [];
    return [...(catalog.animals || []), ...(catalog.supplies || [])];
}

function filteredCatalog() {
    const query = shopQuery.trim().toLowerCase();
    return catalogItems().filter((item) => {
        if (shopCategory !== 'all' && item.category !== shopCategory) return false;
        if (!query) return true;
        return item.label.toLowerCase().includes(query) || item.description.toLowerCase().includes(query);
    });
}

function renderShop() {
    const shop = $('shop');
    if (!catalog) {
        shop.classList.add('hidden');
        shop.setAttribute('aria-hidden', 'true');
        return;
    }

    shop.classList.remove('hidden');
    shop.setAttribute('aria-hidden', 'false');
    $('shop-title').textContent = catalog.shopName || 'Companion Emporium';

    const cats = [{ id: 'all', label: 'All' }, ...(catalog.categories || [])];
    $('shop-cats').innerHTML = cats.map((cat) => (
        `<button type="button" class="${shopCategory === cat.id ? 'active' : ''}" data-cat="${cat.id}">${cat.label}</button>`
    )).join('');

    const items = filteredCatalog();
    $('shop-grid').innerHTML = items.map((item) => `
        <button type="button" class="shop-card ${shopSelected && shopSelected.name === item.name ? 'active' : ''}" data-item="${item.name}">
            <div class="art"><img alt="" src="${item.image}" onerror="this.style.display='none'" /></div>
            <div class="meta">
                <h3>${item.label}</h3>
                <span class="price">${money(item.price)}</span>
            </div>
            <p>${item.category === 'supplies' ? 'Supply' : item.canAttack ? 'Can guard' : 'Companion'}</p>
            <span class="rarity ${item.rarity || ''}">${rarityLabel(item.rarity)}</span>
        </button>
    `).join('') || '<p class="hint">No companions match that search.</p>';

    const detail = $('shop-detail');
    if (!shopSelected) {
        detail.classList.add('hidden');
        return;
    }

    detail.classList.remove('hidden');
    detail.innerHTML = `
        <img alt="" src="${shopSelected.image}" onerror="this.style.display='none'" />
        <span class="rarity ${shopSelected.rarity || ''}">${rarityLabel(shopSelected.rarity)}</span>
        <h3>${shopSelected.label}</h3>
        <p>${shopSelected.description}</p>
        <button class="buy-btn" type="button" data-buy="${shopSelected.name}" ${buying ? 'disabled' : ''}>
            ${buying ? 'Purchasing…' : `Adopt · ${money(shopSelected.price)}`}
        </button>
    `;
}

function openShop(data) {
    catalog = data;
    shopCategory = 'all';
    shopQuery = '';
    shopSelected = (data.animals && data.animals[0]) || null;
    $('shop-search').value = '';
    renderShop();
}

function closeShopUi() {
    $('shop').classList.add('hidden');
    $('shop').setAttribute('aria-hidden', 'true');
    catalog = null;
    shopSelected = null;
}

function showToast(text) {
    const existing = document.querySelector('.toast');
    if (existing) existing.remove();
    const el = document.createElement('div');
    el.className = 'toast';
    el.textContent = text;
    document.body.appendChild(el);
    setTimeout(() => el.remove(), 2400);
}

window.addEventListener('message', (event) => {
    const msg = event.data || {};
    if (msg.action === 'open' || msg.action === 'update') {
        applyMenuBox(msg.menu);
        applyData(msg.data);
    }
    if (msg.action === 'close') {
        $('app').classList.add('hidden');
        $('app').setAttribute('aria-hidden', 'true');
        state = null;
    }
    if (msg.action === 'openShop') {
        openShop(msg.data || {});
    }
    if (msg.action === 'closeShop') {
        closeShopUi();
    }
});

document.addEventListener('click', (event) => {
    if (event.target.closest('#btn-close')) {
        nui('close');
        if (!isFiveM) $('app').classList.add('hidden');
        return;
    }

    if (event.target.closest('#shop-close')) {
        nui('closeShop');
        if (!isFiveM) closeShopUi();
        return;
    }

    const switchBtn = event.target.closest('.pet-chip');
    if (switchBtn) {
        selectedId = switchBtn.getAttribute('data-id');
        nui('select', { petId: selectedId });
        renderKennel();
        return;
    }

    const catBtn = event.target.closest('#shop-cats button');
    if (catBtn) {
        shopCategory = catBtn.getAttribute('data-cat');
        renderShop();
        return;
    }

    const card = event.target.closest('.shop-card');
    if (card) {
        shopSelected = catalogItems().find((item) => item.name === card.getAttribute('data-item')) || null;
        renderShop();
        return;
    }

    const buyBtn = event.target.closest('[data-buy]');
    if (buyBtn && !buyBtn.disabled) {
        const itemName = buyBtn.getAttribute('data-buy');
        buying = true;
        renderShop();
        const finish = (res) => {
            buying = false;
            showToast((res && res.message) || (res && res.ok ? 'Purchased.' : 'Purchase failed.'));
            renderShop();
        };
        if (!isFiveM) {
            finish({ ok: true, message: `Preview adopt: ${itemName}` });
            return;
        }
        nui('buy', { item: itemName }).then(finish);
        return;
    }

    const actionBtn = event.target.closest('.action-nav button');
    if (actionBtn && actionBtn.disabled) {
        const why = actionBtn.getAttribute('title');
        if (why) $('hint').textContent = why;
        return;
    }
    if (actionBtn && !actionBtn.disabled) {
        const action = actionBtn.getAttribute('data-action');
        if (!isFiveM) {
            const pet = selectedPet();
            if (pet) {
                if (action === 'feed') pet.hunger = Math.min(100, pet.hunger + 42);
                if (action === 'water') pet.thirst = Math.min(100, pet.thirst + 48);
                if (action === 'pet') pet.happiness = Math.min(100, pet.happiness + 14);
                if (action === 'toggle') {
                    pet.spawned = !pet.spawned;
                    if (!pet.spawned) pet.walking = false;
                }
                if (action === 'walk' && pet.collar) pet.walking = true;
                if (action === 'unwalk') pet.walking = false;
                if (action === 'collar') pet.collar = true;
                if (action === 'revive') {
                    pet.dead = false;
                    pet.health = 55;
                    pet.hunger = 50;
                    pet.thirst = 50;
                    pet.happiness = 35;
                }
                renderKennel();
            }
            return;
        }
        nui('action', { action: action, petId: selectedId });
    }
});

document.addEventListener('input', (event) => {
    if (event.target.id === 'shop-search') {
        shopQuery = event.target.value;
        renderShop();
    }
});

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        if (catalog) {
            nui('closeShop');
            if (!isFiveM) closeShopUi();
            return;
        }
        nui('close');
        if (!isFiveM) $('app').classList.add('hidden');
    }
});

if (!isFiveM) {
    document.body.classList.add('preview');
    window.addEventListener('DOMContentLoaded', () => {
        applyMenuBox({ top: '18px', right: '18px', width: 392 });
        if (location.hash === '#shop') {
            openShop(MOCK_CATALOG);
        } else {
            applyData(MOCK);
        }
    });
}
