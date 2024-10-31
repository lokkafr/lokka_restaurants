return {
    ['test_craft'] = {
        Menu = {
            title = 'Test Burger',
            icon = 'fas fa-burger',
        },
        Progress = {
            time = 5000,
            label = 'Making burger...',
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle'
            }
        },
        Cost = { { 'bandage', 1 } },
        Pay = { { 'testburger', 1 } },
    }
}