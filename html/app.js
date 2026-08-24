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
};

const ACTIONS = [
    { id: 'toggle', label: 'Call / Recall' },
    { id: 'pet', label: 'Pet' },
    { id: 'feed', label: 'Feed' },
    { id: 'water', label: 'Water' },
    { id: 'walk', label: 'Walk' },
    { id: 'unwalk', label: 'End walk' },
    { id: 'sit', label: 'Sit' },
    { id: 'stay', label: 'Stay' },
    { id: 'follow', label: 'Follow' },
    { id: 'attack', label: 'Attack' },
    { id: 'collar', label: 'Put collar on' },
    { id: 'revive', label: 'Revive' },
    { id: 'rename', label: 'Rename' },
];

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
            if (!pet.canAttack) return { disabled: true, hint: 'Only dogs can attack.' };
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

    const spec = SPECIES[pet.species] || { glyph: 'PT', color: '#5a5044', label: pet.speciesLabel };
    $('badge').style.background = `radial-gradient(circle at 50% 38%, rgba(255,255,255,0.12), transparent 52%), ${spec.color}`;
    $('badge-glyph').textContent = spec.glyph;
    $('pet-name').textContent = pet.name;
    $('pet-meta').textContent = `${pet.speciesLabel} · ${pet.ageDays} day${pet.ageDays === 1 ? '' : 's'} old`;
    $('pet-level').textContent = `Lv ${pet.level}`;
    $('bond-fill').style.width = `${Math.max(0, Math.min(100, pet.bond))}%`;

    $('pet-switcher').innerHTML = state.pets.map((entry) => {
        const active = entry.petId === pet.petId ? 'active' : '';
        const mark = entry.dead ? ' (down)' : entry.spawned ? ' (out)' : '';
        return `<button type="button" class="${active}" data-id="${entry.petId}">${entry.name}${mark}</button>`;
    }).join('');

    const chips = [];
    chips.push(`<li class="${pet.dead ? 'dead' : 'on'}">${pet.dead ? 'Deceased' : 'Alive'}</li>`);
    chips.push(`<li class="${pet.spawned ? 'on' : ''}">${pet.spawned ? 'Out' : 'Home'}</li>`);
    chips.push(`<li class="${pet.collar ? 'on' : ''}">${pet.collar ? 'Collared' : 'No collar'}</li>`);
    chips.push(`<li class="${pet.walking ? 'on' : ''}">${pet.walking ? 'On leash' : 'No leash'}</li>`);
    if (pet.canAttack) chips.push('<li class="on">Can attack</li>');
    $('chips').innerHTML = chips.join('');

    const stats = [
        ['Health', 'health', pet.health],
        ['Hunger', 'hunger', pet.hunger],
        ['Thirst', 'thirst', pet.thirst],
        ['Mood', 'mood', pet.happiness],
    ];
    $('stats').innerHTML = stats.map(([label, cls, value]) => `
        <div class="stat">
            <span>${label}</span>
            <div class="track"><div class="fill ${cls}" style="width:${value}%"></div></div>
            <b>${Math.round(value)}</b>
        </div>
    `).join('');

    let hint = '';
    $('actions').innerHTML = ACTIONS.map((action) => {
        const info = actionState(action.id, pet);
        if (info.hint && !info.disabled && !hint) hint = info.hint;
        if (info.disabled && info.hint && action.id === 'walk' && !pet.collar) hint = info.hint;
        const danger = action.id === 'attack' || action.id === 'revive' ? 'danger' : '';
        return `<button type="button" class="${danger}" data-action="${action.id}" ${info.disabled ? 'disabled' : ''} title="${info.hint || ''}">${action.label}</button>`;
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
    const switchBtn = event.target.closest('.switcher button');
    if (switchBtn) {
        selectedId = switchBtn.getAttribute('data-id');
        nui('select', { petId: selectedId });
        render();
        return;
    }
    const actionBtn = event.target.closest('.actions button');
    if (actionBtn && !actionBtn.disabled) {
        const action = actionBtn.getAttribute('data-action');
        if (!isFiveM) {
            const pet = selectedPet();
            if (pet) {
                if (action === 'feed') pet.hunger = Math.min(100, pet.hunger + 42);
                if (action === 'water') pet.thirst = Math.min(100, pet.thirst + 48);
                if (action === 'pet') pet.happiness = Math.min(100, pet.happiness + 14);
                if (action === 'toggle') pet.spawned = !pet.spawned;
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
        applyData(MOCK);
    });
}
