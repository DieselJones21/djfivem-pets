const isFiveM = typeof GetParentResourceName === 'function';

const SPECIES = {
    pet_rottweiler: { glyph: 'RT', color: '#6d3b32', label: 'Rottweiler' },
    pet_shepherd: { glyph: 'GS', color: '#5c4632', label: 'Shepherd' },
    pet_husky: { glyph: 'HK', color: '#4e5c68', label: 'Husky' },
    pet_retriever: { glyph: 'RV', color: '#8a6230', label: 'Retriever' },
    pet_pug: { glyph: 'PG', color: '#7a5a46', label: 'Pug' },
    pet_poodle: { glyph: 'PD', color: '#6b5b73', label: 'Poodle' },
    pet_chop: { glyph: 'CH', color: '#3f3a36', label: 'Chop' },
    pet_cat: { glyph: 'CT', color: '#8a7048', label: 'Cat' },
    pet_rabbit: { glyph: 'RB', color: '#7d7468', label: 'Rabbit' },
    pet_pig: { glyph: 'PI', color: '#8b5664', label: 'Pig' },
    pet_monkey: { glyph: 'MK', color: '#6b5340', label: 'Monkey' },
    pet_coyote: { glyph: 'CY', color: '#8a7048', label: 'Coyote' },
    pet_mtlion: { glyph: 'ML', color: '#9a6b2e', label: 'Mountain Lion' },
};

const ACTIONS = [
    { id: 'toggle', label: 'Call out' },
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
            species: 'pet_rottweiler',
            speciesLabel: 'Rottweiler',
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
            species: 'pet_cat',
            speciesLabel: 'Cat',
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
            name: 'Kong',
            species: 'pet_monkey',
            speciesLabel: 'Monkey',
            canAttack: true,
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
            name: 'Dust',
            species: 'pet_coyote',
            speciesLabel: 'Coyote',
            canAttack: true,
            dead: false,
            collar: false,
            spawned: false,
            walking: false,
            sitting: false,
            health: 88,
            hunger: 50,
            thirst: 44,
            happiness: 60,
            bond: 8,
            level: 1,
            ageDays: 5,
        },
        {
            petId: 'demo-6',
            name: 'Ridge',
            species: 'pet_mtlion',
            speciesLabel: 'Mountain Lion',
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

let state = null;
let selectedId = null;

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
                ? { disabled: true, hint: 'Revive this pet before calling it.' }
                : { disabled: false, hint: pet.spawned ? 'Send them home.' : 'Use the pet item or call them out.' };
        case 'pet':
            return out ? { disabled: false } : { disabled: true, hint: 'Call your pet first.' };
        case 'feed':
            if (!out) return { disabled: true, hint: 'Call your pet first.' };
            if (!supplies.food) return { disabled: true, hint: 'You need pet food.' };
            return { disabled: false };
        case 'water':
            if (!out) return { disabled: true, hint: 'Call your pet first.' };
            if (!supplies.water) return { disabled: true, hint: 'You need pet water.' };
            return { disabled: false };
        case 'walk':
            if (!out) return { disabled: true, hint: 'Call your pet first.' };
            if (pet.walking) return { disabled: true, hint: 'Already on a walk.' };
            if (!pet.collar) return { disabled: true, hint: 'Put a collar on them first.' };
            if (!supplies.leash) return { disabled: true, hint: 'You need a leash in your inventory.' };
            return { disabled: false, hint: 'Collar and leash required.' };
        case 'unwalk':
            return pet.walking ? { disabled: false } : { disabled: true, hint: 'You are not walking this pet.' };
        case 'sit':
        case 'stay':
        case 'follow':
            return out ? { disabled: false } : { disabled: true, hint: 'Call your pet first.' };
        case 'attack':
            if (!pet.canAttack) return { disabled: true, hint: 'This animal cannot attack.' };
            if (!out) return { disabled: true, hint: 'Call your pet first.' };
            return { disabled: false, hint: 'Aim at a target, then send them.' };
        case 'collar':
            if (pet.dead) return { disabled: true, hint: 'Revive them first.' };
            if (!out) return { disabled: true, hint: 'Call your pet first.' };
            if (pet.collar) return { disabled: true, hint: 'Already collared.' };
            if (!supplies.collar) return { disabled: true, hint: 'You need a pet collar.' };
            return { disabled: false };
        case 'revive':
            if (!pet.dead) return { disabled: true, hint: 'This pet is alive.' };
            if (!supplies.revive) return { disabled: true, hint: 'You need a pet revive kit.' };
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

function render() {
    const pet = selectedPet();
    const app = $('app');
    if (!pet) {
        app.classList.add('hidden');
        app.setAttribute('aria-hidden', 'true');
        return;
    }

    app.classList.remove('hidden');
    app.setAttribute('aria-hidden', 'false');

    const spec = SPECIES[pet.species] || { glyph: 'PT', color: '#2a2a2a', label: pet.speciesLabel };
    $('badge').style.background = spec.color;
    $('badge-glyph').textContent = spec.glyph;
    $('pet-name').textContent = pet.name;
    $('pet-meta').textContent = pet.speciesLabel;
    $('pet-level').textContent = pet.dead ? 'Down' : `Lv ${pet.level}`;

    $('pet-switcher').innerHTML = state.pets.map((entry) => {
        const active = entry.petId === pet.petId ? 'active' : '';
        const mark = entry.dead ? ' · down' : entry.spawned ? ' · out' : '';
        return `<button type="button" class="${active}" data-id="${entry.petId}">${entry.name}${mark}</button>`;
    }).join('');

    const segs = [];
    segs.push(`<span class="${pet.dead ? 'dead' : 'on'}">${pet.dead ? 'Down' : 'Alive'}</span>`);
    segs.push(`<span class="${pet.spawned ? 'on' : ''}">${pet.spawned ? 'Out' : 'Home'}</span>`);
    if (pet.collar) segs.push('<span class="on">Collar</span>');
    if (pet.walking) segs.push('<span class="on">Leash</span>');
    $('chips').innerHTML = segs.join('');

    const stats = [
        ['Health', pet.health],
        ['Hunger', pet.hunger],
        ['Thirst', pet.thirst],
        ['Mood', pet.happiness],
    ];
    $('stats').innerHTML = stats.map(([label, value]) => {
        const n = Math.round(value);
        const trend = n >= 70 ? 'up' : n <= 25 ? 'down' : '';
        const arrow = n >= 70 ? '↑' : n <= 25 ? '↓' : '';
        return `
            <article class="metric">
                <p class="metric-label">${label}</p>
                <div class="metric-row">
                    <strong>${n}</strong>
                    <span class="trend ${trend}">${arrow} ${n}%</span>
                </div>
            </article>
        `;
    }).join('');

    let hint = '';
    $('actions').innerHTML = ACTIONS.map((action) => {
        const info = actionState(action.id, pet);
        if (info.hint && !info.disabled && !hint) hint = info.hint;
        if (info.disabled && info.hint && action.id === 'walk' && !pet.collar) hint = info.hint;
        const primary = action.id === 'toggle' ? 'primary' : '';
        const label = action.id === 'toggle'
            ? (pet.spawned ? 'Put away' : 'Call out')
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
    render();
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
});

document.addEventListener('click', (event) => {
    const close = event.target.closest('#btn-close');
    if (close) {
        nui('close');
        if (!isFiveM) {
            $('app').classList.add('hidden');
        }
        return;
    }
    const switchBtn = event.target.closest('.nav-pills button');
    if (switchBtn) {
        selectedId = switchBtn.getAttribute('data-id');
        nui('select', { petId: selectedId });
        render();
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
                render();
            }
            return;
        }
        nui('action', { action: action, petId: selectedId });
    }
});

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        nui('close');
        if (!isFiveM) $('app').classList.add('hidden');
    }
});

if (!isFiveM) {
    document.body.classList.add('preview');
    window.addEventListener('DOMContentLoaded', () => {
        applyMenuBox({ top: '16px', right: '16px', width: 348 });
        applyData(MOCK);
    });
}
