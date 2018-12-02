RSpec.describe ReadableRailsLog::SqlDeNormalizer do

  def de_normalize(sql_log)
    ReadableRailsLog::SqlDeNormalizer.effect( sql_log )
  end

  context 'with two params' do
    let(:where_log) do
      <<-LOG
User Load (5.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = $1 AND "users"."archived" = $2 ORDER BY "users"."id" ASC LIMIT $3  [["id", 2646], ["archived", "f"], ["LIMIT", 1]]
LOG
    end


    it "de-normalises the query" do
      freeze_time do
        expect( de_normalize( where_log ) ).to eq 'User Load (5.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = 2646 AND "users"."archived" = \'f\' ORDER BY "users"."id" ASC LIMIT 1'
      end
    end
  end

  context 'without any params' do
    let(:basic_select) do
      <<-LOG
(2.8ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC
LOG
    end

    it "doesnt change the query" do
      expect( de_normalize( basic_select ) ).to eq basic_select
    end
  end
end
