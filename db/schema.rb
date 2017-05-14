# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170514174115) do

  create_table "events", force: :cascade do |t|
    t.float    "artigos_qualis_a1"
    t.float    "artigos_qualis_a2"
    t.float    "artigos_qualis_b1"
    t.float    "artigos_qualis_b2"
    t.float    "artigos_qualis_b3"
    t.float    "artigos_qualis_b4"
    t.float    "artigos_qualis_b5"
    t.float    "artigos_qualis_c"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "user_id"
    t.string   "event_name"
    t.float    "artigos_qualis_a1_max"
    t.float    "artigos_qualis_a2_max"
    t.float    "artigos_qualis_b1_max"
    t.float    "artigos_qualis_b2_max"
    t.float    "artigos_qualis_b3_max"
    t.float    "artigos_qualis_b4_max"
    t.float    "artigos_qualis_b5_max"
    t.float    "artigos_qualis_c_max"
    t.float    "livros"
    t.float    "livros_max"
    t.float    "capitulos_de_livros"
    t.float    "capitulos_de_livros_max"
    t.float    "projetos_de_pesquisa"
    t.float    "projetos_de_pesquisa_max"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_a1"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_a1_max"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_a2"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_a2_max"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b1"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b1_max"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b2"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b2_max"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b3"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b3_max"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b4"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b4_max"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b5"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_b5_max"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_c"
    t.float    "trabalhos_completos_em_anais_de_congresso_qualis_c_max"
    t.float    "resumos_em_anais_de_congresso_qualis_a1"
    t.float    "resumos_em_anais_de_congresso_qualis_a1_max"
    t.float    "resumos_em_anais_de_congresso_qualis_a2"
    t.float    "resumos_em_anais_de_congresso_qualis_a2_max"
    t.float    "resumos_em_anais_de_congresso_qualis_b1"
    t.float    "resumos_em_anais_de_congresso_qualis_b1_max"
    t.float    "resumos_em_anais_de_congresso_qualis_b2"
    t.float    "resumos_em_anais_de_congresso_qualis_b2_max"
    t.float    "resumos_em_anais_de_congresso_qualis_b3"
    t.float    "resumos_em_anais_de_congresso_qualis_b3_max"
    t.float    "resumos_em_anais_de_congresso_qualis_b4"
    t.float    "resumos_em_anais_de_congresso_qualis_b4_max"
    t.float    "resumos_em_anais_de_congresso_qualis_c"
    t.float    "resumos_em_anais_de_congresso_qualis_c_max"
    t.float    "bancas_graduacao"
    t.float    "bancas_graduacao_max"
    t.float    "bancas_mestrado"
    t.float    "bancas_mestrado_max"
    t.float    "bancas_doutorado"
    t.float    "bancas_doutorado_max"
    t.float    "bancas_especializacao"
    t.float    "bancas_especializacao_max"
    t.float    "orientacoes_mestrado"
    t.float    "orientacoes_mestrado_max"
    t.float    "orientacoes_doutorado"
    t.float    "orientacoes_doutorado_max"
    t.float    "orientacoes_outras"
    t.float    "orientacoes_outras_max"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.boolean  "admin",           default: false
  end

end
