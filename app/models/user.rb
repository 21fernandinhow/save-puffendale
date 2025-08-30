class User < ApplicationRecord
    has_secure_password
    
    has_many :task_lists, dependent: :destroy
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true

    ACHIEVEMENTS = [
        { description: "Uma risada sincera volta a ser ouvida no vilarejo, depois de muito tempo...", points_required: 10 },
        { description: "O mercado volta a abrir suas portas!", points_required: 20 },
        { description: "A primeira árvore floresce novamente.", points_required: 30 },
        { description: "A fonte da praça jorra água cristalina.", points_required: 50 },
        { description: "Crianças voltam a brincar nas ruas.", points_required: 60 },
        { description: "O ferreiro reabre sua oficina.", points_required: 80 },
        { description: "Surge uma ruga na testa da bruxa, seu feitiço de juventude está perdendo força...", points_required: 90 },
        { description: "Os passáros voltaram a cantar!", points_required: 100 },
        { description: "As fazendas voltaram a dar colheitas!", points_required: 120 },
        { description: "Novas casas são reconstruídas.", points_required: 150 },
        { description: "Animais retornam às pastagens.", points_required: 170 },
        { description: "A bruxa perde seu primeiro aliado.", points_required: 200 },
        { description: "O vilarejo celebra sua primeira festa após anos !", points_required: 210 },
        { description: "O poço central brilha com energia curativa.", points_required: 230 },
        { description: "Bardos começam a visitar a cidade com histórias e cantorias!", points_required: 250 },
        { description: "A bruxa começa a sentir medo do vilarejo.", points_required: 280 },
        { description: "As festividades se tornam semanais.", points_required: 300 },
        { description: "O vilarejo é agora seguro durante a noite.", points_required: 350 },
        { description: "A bruxa está velha e fraca.", points_required: 380 },
        { description: "O vilarejo brilha como um lugar feliz e próspero.", points_required: 400 }
    ]

    def unlocked_achievements
        ACHIEVEMENTS.select { |item| item[:points_required] <= magic_points }
    end
end