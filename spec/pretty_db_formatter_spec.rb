RSpec.describe ReadableRailsLog::PrettyDbFormatter do

  def pretty(msg)
    ReadableRailsLog::PrettyDbFormatter.new.call(
      nil,
      Chronic.parse('4 Jan 2020 at 4pm'),
      nil, msg
    )
  end

  let(:basic_select) do
    <<-LOG
(2.8ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC
LOG
  end

  it "breaks SELECT, FROM, ORDER BY into new lines" do
    freeze_time do
      expect( pretty( basic_select ) ).to eq <<-LOG
#{Rainbow('16:00:00:000').red} (2.8ms)\s\s
#{Rainbow('SELECT').cyan}
 "schema_migrations"."version"\s
#{Rainbow('FROM').cyan}
 "schema_migrations"\s
#{Rainbow('ORDER BY').cyan}
 "schema_migrations"."version" ASC

---
LOG
    end
  end

  let(:where_log) do
    <<-LOG
User Load (5.7ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = $1 ORDER BY "users"."id" ASC LIMIT $2  [["id", 2646], ["LIMIT", 1]]
LOG
  end

  it "breaks WHERE into new lines" do
    freeze_time do
      expect( pretty( where_log ) ).to eq <<-LOG
#{Rainbow('16:00:00:000').red} User Load (5.7ms)\s\s
#{Rainbow('SELECT').cyan}
  "users".*\s
#{Rainbow('FROM').cyan}
 "users"\s
#{Rainbow('WHERE').cyan}
 "users"."id" = 2646\s
#{Rainbow('ORDER BY').cyan}
 "users"."id" ASC
#{Rainbow('LIMIT 1').cyan}
---
LOG
    end
  end

  let(:complex) do
    <<-LOG
(15.2ms)  SELECT SUM(location_analytics.emails_sent_counter), SUM(location_analytics.emails_opened_counter), SUM(location_analytics.emails_clicked_through_counter) FROM "location_analytics" INNER JOIN "locations" ON "locations"."id" = "location_analytics"."location_id" AND "locations"."active" = $1 WHERE "location_analytics"."survey_type" = $2 AND "location_analytics"."review_request" = $3 AND (date BETWEEN '2018-02-17' AND '2018-03-17') AND "locations"."id" IN (SELECT "locations"."id" FROM "locations" LEFT OUTER JOIN "owners" ON "owners"."id" = "locations"."owner_id" WHERE "locations"."active" = $6 AND (EXISTS (SELECT * FROM permissions WHERE permissions.permissible_type = 'Company' AND permissions.permissible_id = owners.company_id AND permissions.feature_id = 2)) AND (NOT EXISTS (SELECT * FROM restrictions WHERE restrictions.restrictable_type = 'Location' AND restrictions.restrictable_id = locations.id AND restrictions.feature_id = 2)))  [["active", "t"], ["survey_type", 0], ["review_request", "f"], ["active", "t"], ["active", "t"], ["active", "t"], ["active", "t"]]
LOG
  end

  it "handles complex queries" do
    freeze_time do
      expect(pretty complex).to eq <<-LOG
#{Rainbow('16:00:00:000').red} (15.2ms)\s\s
#{Rainbow('SELECT').cyan}
 SUM(location_analytics.emails_sent_counter),
 SUM(location_analytics.emails_opened_counter),
 SUM(location_analytics.emails_clicked_through_counter)\s
#{Rainbow('FROM').cyan}
 "location_analytics" #{Rainbow('INNER JOIN').green}
 "locations" #{Rainbow('ON').green}
 "locations"."id" = "location_analytics"."location_id" AND
 "locations"."active" = 't'\s
#{Rainbow('WHERE').cyan}
 "location_analytics"."survey_type" = 0 AND
 "location_analytics"."review_request" = 'f' AND
 (date BETWEEN
 '2018-02-17' AND
 '2018-03-17') AND
 "locations"."id" #{Rainbow('IN (').blue}
#{Rainbow('SELECT').cyan}
 "locations"."id"\s
#{Rainbow('FROM').cyan}
 "locations" #{Rainbow('LEFT OUTER JOIN').green}
 "owners" #{Rainbow('ON').green}
 "owners"."id" = "locations"."owner_id"\s
#{Rainbow('WHERE').cyan}
 "locations"."active" = 't' AND
 #{Rainbow('(EXISTS (').blue}
#{Rainbow('SELECT').cyan}
 *\s
#{Rainbow('FROM').cyan}
 permissions\s
#{Rainbow('WHERE').cyan}
 permissions.permissible_type = 'Company' AND
 permissions.permissible_id = owners.company_id AND
 permissions.feature_id = 2)) AND
 #{Rainbow('(NOT EXISTS (').blue}
#{Rainbow('SELECT').cyan}
 *\s
#{Rainbow('FROM').cyan}
 restrictions\s
#{Rainbow('WHERE').cyan}
 restrictions.restrictable_type = 'Location' AND
 restrictions.restrictable_id = locations.id AND
 restrictions.feature_id = 2)))
---
LOG
    end
  end
end
